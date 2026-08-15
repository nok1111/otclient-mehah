#include "voicemanager.h"
#include <framework/core/application.h>
#include <framework/sound/soundmanager.h>
#include <framework/core/eventdispatcher.h>
#include <framework/core/clock.h>
#include <framework/stdext/string.h>
#include <framework/util/crypt.h>
#include <openssl/hmac.h>
#include <openssl/evp.h>
#include <openssl/sha.h>
#include <cstring>
#include <algorithm>
#include <ctime>
#include <chrono>
#include <thread>
#include <queue>
#include <set>
#include <windows.h>
#include <mmsystem.h>
#include <fmt/format.h>


VoiceManager::VoiceManager()
    : m_connected(false)
    , m_authenticated(false)
    , m_muted(false)
    , m_leaving(false)
    , m_testMode(false)
    , m_testThreadRunning(false)
    , m_isJoining(false)
    , m_relayPort(0)
    , m_cid(0)
    , m_encoder(nullptr)
    , m_decoder(nullptr)
    , m_shouldStop(false)
    , m_sequenceNumber(0)
    , m_voiceSecret("1234-5678-1234-1234")
    , m_waveIn(nullptr)
    , m_audioCaptureInitialized(false)
    , m_audioDevice(nullptr)
    , m_audioContext(nullptr)
    , m_audioSource(0)
    , m_currentChannelType(VoiceChannelType::WORLD)
    , m_currentChannelId("")
    , m_masterVolume(1.0f)
{
    m_captureBuffer.resize(FRAME_SIZE);
    m_playbackBuffer.resize(FRAME_SIZE);
}

VoiceManager::~VoiceManager()
{
    try {
        //g_logger.info("VoiceManager destructor called");
        
        // Stop test mode
        m_testMode = false;
        m_testThreadRunning = false;
        m_isJoining = false;
        
        // Stop any ongoing operations
        m_shouldStop = true;
        m_connected = false;
        m_authenticated = false;
        
        // Close socket first to unblock any pending operations
        if (m_socket && m_socket->is_open()) {
            try {
                m_socket->close();
            } catch (...) {
                // Ignore exceptions during destruction
            }
        }
        
        // Wait for threads to finish
        if (m_connectionThread.joinable()) {
            try {
                std::this_thread::sleep_for(std::chrono::milliseconds(50));
                if (m_connectionThread.joinable()) {
                    m_connectionThread.detach();
                }
            } catch (...) {
                // Ignore exceptions during destruction
            }
        }
        
        if (m_receiveThread.joinable()) {
            try {
                std::this_thread::sleep_for(std::chrono::milliseconds(50));
                if (m_receiveThread.joinable()) {
                    m_receiveThread.detach(); // Detach instead of join in destructor
                }
            } catch (...) {
                // Ignore exceptions during destruction
            }
        }
        
        if (m_testPlaybackThread.joinable()) {
            try {
                std::this_thread::sleep_for(std::chrono::milliseconds(50));
                if (m_testPlaybackThread.joinable()) {
                    m_testPlaybackThread.detach();
                }
            } catch (...) {
                // Ignore exceptions during destruction
            }
        }
        
        // Clean up audio resources
        try {
            cleanupAudio();
        } catch (...) {
            // Ignore exceptions during destruction
        }
        
        //g_logger.info("VoiceManager destructor completed");
    } catch (...) {
        // Catch any unexpected exceptions to prevent crashes during destruction
    }
}

bool VoiceManager::join(const std::string& host, uint16_t port, const std::string& room, const std::string& token, uint32_t cid)
{
    // Check if already joining
    if (m_isJoining) {
        g_logger.warning("Already joining a room, please wait...");
        return false;
    }
    
    // Verify token BEFORE starting async operation (this is quick)
    if (!verifyToken(token)) {
        g_logger.error("Invalid voice token");
        return false;
    }
    
    //g_logger.info(fmt::format("Starting async join to voice room: {}", room));
    
    // Clean up old connection thread if exists
    if (m_connectionThread.joinable()) {
        try {
            m_connectionThread.detach();
        } catch (...) {
            g_logger.warning("Exception detaching old connection thread");
        }
    }
    
    // Start connection in a separate thread to avoid blocking UI
    m_connectionThread = std::thread([this, host, port, room, token, cid]() {
        asyncJoinRoom(host, port, room, token, cid);
    });
    
    return true;
}

void VoiceManager::asyncJoinRoom(const std::string& host, uint16_t port, const std::string& room, const std::string& token, uint32_t cid)
{
    m_isJoining = true;
    
    try {
        //g_logger.info(fmt::format("Async join thread started for room: {}", room));
        
        // Disable test mode if enabled (clean up before new connection)
        if (m_testMode) {
            //g_logger.info("Disabling test mode before joining new room...");
            try {
                disableTest();
            } catch (const std::exception& e) {
                g_logger.error(fmt::format("Error disabling test mode: {}", e.what()));
            }
        }
        
        // Force cleanup of previous connection if any
        // Set flags first to signal any running threads to stop
        m_shouldStop = true;
        m_connected = false;
        m_authenticated = false;
        
        // Clean up receive thread if it exists
        if (m_receiveThread.joinable()) {
            //g_logger.info("Cleaning up previous receive thread...");
            try {
                // Close socket to unblock the thread
                if (m_socket && m_socket->is_open()) {
                    m_socket->close();
                }
                
                // Give thread time to exit
                std::this_thread::sleep_for(std::chrono::milliseconds(300));
                
                // Try to join, or detach if it takes too long
                if (m_receiveThread.joinable()) {
                    m_receiveThread.detach();
                    //g_logger.info("Previous receive thread detached");
                }
            } catch (const std::exception& e) {
                g_logger.error(fmt::format("Error cleaning up receive thread: {}", e.what()));
                if (m_receiveThread.joinable()) {
                    m_receiveThread.detach();
                }
            }
        }
        
        // Clean up socket and connection
        if (m_socket && m_socket->is_open()) {
            try {
                m_socket->close();
            } catch (...) {
                g_logger.warning("Exception closing old socket");
            }
        }
        m_socket.reset();
        m_ioContext.reset();
        
        // Clean up audio resources
        try {
            cleanupAudio();
        } catch (const std::exception& e) {
            g_logger.error(fmt::format("Error cleaning up audio: {}", e.what()));
        }
        
        //g_logger.info("Previous connection cleaned up, starting new connection...");
        
        // Now start fresh
        m_relayHost = host;
        m_relayPort = port;
        m_roomId = room;
        m_token = token;
        m_cid = cid;
        
        if (!initializeAudio()) {
            g_logger.error("Failed to initialize audio");
            m_isJoining = false;
            return;
        }
        
        if (!connectToRelay(host, port)) {
            g_logger.error("Failed to connect to voice relay");
            cleanupAudio();
            m_isJoining = false;
            return;
        }
        
        // Reset flags for new connection
        m_connected = true;
        m_authenticated = false;
        m_shouldStop = false;
        m_leaving = false;
        
        // Wait a bit for the authentication token to be sent before starting receive thread
        std::this_thread::sleep_for(std::chrono::milliseconds(200));
        
        // Start new receive thread
        m_receiveThread = std::thread(&VoiceManager::receivePackets, this);
        
        //g_logger.info(fmt::format("Successfully joined voice room: {}", room));
        m_isJoining = false;
        
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Exception in async join: {}", e.what()));
        m_isJoining = false;
        m_connected = false;
    } catch (...) {
        g_logger.error("Unknown exception in async join");
        m_isJoining = false;
        m_connected = false;
    }
}

void VoiceManager::leave()
{
    if (m_leaving) {
        //g_logger.info("Leave called but already leaving");
        return;
    }
    
    if (!m_connected && !m_isJoining) {
        //g_logger.info("Leave called but not connected");
        return;
    }
    
    //g_logger.info("Leaving voice room...");
    
    try {
        // Set leaving flag to prevent multiple calls
        m_leaving = true;
        
        // Disable test mode if enabled (quick)
        if (m_testMode) {
            m_testMode = false;
            m_testThreadRunning = false;
        }
        
        // Set connected to false immediately
        m_connected = false;
        m_authenticated = false;
        m_shouldStop = true;
        
        // Close socket immediately to unblock threads (fast operation)
        if (m_socket && m_socket->is_open()) {
            try {
                m_socket->close();
                //g_logger.info("Socket closed");
            } catch (...) {
                g_logger.warning("Exception closing socket");
            }
        }
        
        // Quick check if threads can exit fast
        bool needsSlowCleanup = false;
        
        // Try quick join on receive thread (50ms max)
        if (m_receiveThread.joinable()) {
            // Give it just a moment to detect socket closure
            std::this_thread::sleep_for(std::chrono::milliseconds(50));
            
            // If thread is still running, we need slow cleanup
            if (m_receiveThread.joinable()) {
                needsSlowCleanup = true;
            }
        }
        
        if (!needsSlowCleanup) {
            // Fast path - threads exited quickly, do full cleanup now
            //g_logger.info("Fast cleanup path");
            
            if (m_receiveThread.joinable()) {
                try {
                    m_receiveThread.join();
                } catch (...) {
                    if (m_receiveThread.joinable()) m_receiveThread.detach();
                }
            }
            
            if (m_testPlaybackThread.joinable()) {
                try {
                    m_testPlaybackThread.join();
                } catch (...) {
                    if (m_testPlaybackThread.joinable()) m_testPlaybackThread.detach();
                }
            }
            
            if (m_connectionThread.joinable()) {
                m_connectionThread.detach();
            }
            
            if (m_socket) m_socket.reset();
            if (m_ioContext) m_ioContext.reset();
            
            cleanupAudio();
            
            std::lock_guard<std::mutex> lock(m_testQueueMutex);
            while (!m_testPacketQueue.empty()) {
                m_testPacketQueue.pop();
            }
            
            m_leaving = false;
            m_isJoining = false;
            m_reconnectAttempts = 0;
            m_reconnecting = false;
            clearConnectedPlayers();
            {
                std::lock_guard<std::mutex> lock(m_speakingMutex);
                m_speakingPlayers.clear();
            }
            {
                std::lock_guard<std::mutex> lock(m_mutedPlayersMutex);
                m_mutedPlayers.clear();
            }
            {
                std::lock_guard<std::mutex> jlock(m_jitterMutex);
                m_jitterBuffers.clear();
            }
            m_recvBuffer.clear();
            //g_logger.info("Fast cleanup completed");
            
        } else {
            // Slow path - detach cleanup thread but keep critical waits minimal
            //g_logger.info("Slow cleanup path (thread taking longer)");
            
            // Detach receive thread immediately since it's not responding
            if (m_receiveThread.joinable()) {
                m_receiveThread.detach();
                //g_logger.info("Receive thread detached");
            }
            
            // Detach other threads
            if (m_testPlaybackThread.joinable()) {
                m_testPlaybackThread.detach();
            }
            if (m_connectionThread.joinable()) {
                m_connectionThread.detach();
            }
            
            // Clean up resources immediately (threads are detached, safe to cleanup)
            if (m_socket) m_socket.reset();
            if (m_ioContext) m_ioContext.reset();
            
            cleanupAudio();
            
            {
                std::lock_guard<std::mutex> lock(m_testQueueMutex);
                while (!m_testPacketQueue.empty()) {
                    m_testPacketQueue.pop();
                }
            }
            
            m_leaving = false;
            m_isJoining = false;
            m_reconnectAttempts = 0;
            m_reconnecting = false;
            clearConnectedPlayers();
            {
                std::lock_guard<std::mutex> lock(m_speakingMutex);
                m_speakingPlayers.clear();
            }
            {
                std::lock_guard<std::mutex> lock(m_mutedPlayersMutex);
                m_mutedPlayers.clear();
            }
            {
                std::lock_guard<std::mutex> jlock(m_jitterMutex);
                m_jitterBuffers.clear();
            }
            m_recvBuffer.clear();
            //g_logger.info("Slow cleanup completed (threads detached safely)");
        }
        
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Exception in leave(): {}", e.what()));
        m_leaving = false;
        m_isJoining = false;
    } catch (...) {
        g_logger.error("Unknown exception in leave()");
        m_leaving = false;
        m_isJoining = false;
    }
}

void VoiceManager::mute(bool state)
{
    m_muted = state;
    if (m_socket && m_socket->is_open() && m_authenticated) {
        std::string msg = fmt::format("{{\"action\":\"mute\",\"muted\":{}}}", state ? "true" : "false");
        sendControlMessage(msg);
    }
}

bool VoiceManager::initializeAudio()
{
    int error;
    
    if (!initializeAudioCapture()) {
        g_logger.error("Failed to initialize audio capture");
        return false;
    }
    
    if (!initializeOpenAL()) {
        g_logger.error("Failed to initialize OpenAL");
        cleanupAudioCapture();
        return false;
    }
    m_encoder = opus_encoder_create(SAMPLE_RATE, CHANNELS, OPUS_APPLICATION_VOIP, &error);
    if (error != OPUS_OK) {
        g_logger.error(fmt::format("Failed to create Opus encoder: {}", opus_strerror(error)));
        cleanupOpenAL();
        cleanupAudioCapture();
        return false;
    }
    
    opus_encoder_ctl(m_encoder, OPUS_SET_BITRATE(64000));
    opus_encoder_ctl(m_encoder, OPUS_SET_VBR(1));
    opus_encoder_ctl(m_encoder, OPUS_SET_COMPLEXITY(5));
    
    // Enable DTX (Discontinuous Transmission) to reduce noise/echo
    opus_encoder_ctl(m_encoder, OPUS_SET_DTX(1));
    // Enable FEC (Forward Error Correction) for better quality
    opus_encoder_ctl(m_encoder, OPUS_SET_INBAND_FEC(1));
    // Set packet loss percentage expectation
    opus_encoder_ctl(m_encoder, OPUS_SET_PACKET_LOSS_PERC(10));
    m_decoder = opus_decoder_create(SAMPLE_RATE, CHANNELS, &error);
    if (error != OPUS_OK) {
        g_logger.error(fmt::format("Failed to create Opus decoder: {}", opus_strerror(error)));
        opus_encoder_destroy(m_encoder);
        m_encoder = nullptr;
        cleanupOpenAL();
        cleanupAudioCapture();
        return false;
    }
    
    return true;
}

void VoiceManager::cleanupAudio()
{
    //g_logger.info("Cleaning up audio resources...");
    
    try {
        // Clean up Opus encoder/decoder
        if (m_encoder) {
            opus_encoder_destroy(m_encoder);
            m_encoder = nullptr;
        }
        
        if (m_decoder) {
            opus_decoder_destroy(m_decoder);
            m_decoder = nullptr;
        }
        
        // Clean up OpenAL and audio capture
        cleanupOpenAL();
        cleanupAudioCapture();
        
        //g_logger.info("Audio cleanup completed");
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Exception during audio cleanup: {}", e.what()));
    } catch (...) {
        g_logger.error("Unknown exception during audio cleanup");
    }
}

bool VoiceManager::connectToRelay(const std::string& host, uint16_t port)
{
    try {
        //g_logger.info(fmt::format("Connecting to voice relay at {}:{} using synchronous socket...", host, port));
        
        // Create a new io_context for this socket
        m_ioContext = std::make_unique<asio::io_context>();
        m_socket = std::make_unique<asio::ip::tcp::socket>(*m_ioContext);
        
        // Resolve the host
        asio::ip::tcp::resolver resolver(*m_ioContext);
        auto endpoints = resolver.resolve(host, std::to_string(port));
        
        // Connect synchronously
        asio::connect(*m_socket, endpoints);
        //g_logger.info("TCP socket connected to relay server");
        
        // Send authentication token immediately
        std::string authMessage = "{\"token\":\"" + m_token + "\",\"room\":\"" + m_roomId + "\",\"cid\":" + std::to_string(m_cid) + "}";
        asio::write(*m_socket, asio::buffer(authMessage));
        //g_logger.info("Sent authentication token via synchronous socket");
        
        return true;
        
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Exception in connectToRelay: {}", e.what()));
        if (m_socket && m_socket->is_open()) {
            try {
                m_socket->close();
            } catch (...) {}
        }
        m_socket.reset();
        m_ioContext.reset();
        return false;
    }
}

void VoiceManager::disconnectFromRelay()
{
    if (m_connection) {
        try {
            m_connection->close();
        } catch (const std::exception& e) {
            g_logger.warning(fmt::format("Error closing voice connection: {}", e.what()));
        }
        m_connection.reset();
    }
}

void VoiceManager::processAudio()
{
    static auto lastLog = std::chrono::steady_clock::now();
    static int callCount = 0;
    static int captureSuccess = 0;
    static int encodedPackets = 0;
    static bool firstCall = true;

    if (firstCall) {
        //g_logger.info("ProcessAudio() called for the first time!");
        firstCall = false;
    }

    callCount++;

    if (!m_connected || m_muted) {
        // Still process jitter buffers for playback
        processJitterBuffers();
        return;
    }

    // Push-to-talk: only capture when PTT key is held (if PTT mode is enabled)
    if (m_pushToTalk && !m_pttActive) {
        processJitterBuffers();
        return;
    }

    if (captureAudio()) {
        captureSuccess++;

        // Calculate RMS for VAD and UI VU meter
        double sumSquares = 0.0;
        for (size_t i = 0; i < m_captureBuffer.size(); ++i) {
            sumSquares += (double)m_captureBuffer[i] * m_captureBuffer[i];
        }
        double rms = m_captureBuffer.empty() ? 0.0 : std::sqrt(sumSquares / m_captureBuffer.size());
        m_lastMicLevel.store(static_cast<float>(rms));

        // VAD: check if audio is loud enough to send
        bool shouldSend = true;
        if (m_vadEnabled) {
            shouldSend = rms > m_vadThreshold;
        }

        if (shouldSend) {
            std::vector<uint8_t> opusData = encodeAudio(m_captureBuffer);
            if (!opusData.empty()) {
                encodedPackets++;
                uint32_t timestamp = g_clock.millis();
                sendVoicePacket(opusData, m_sequenceNumber++, timestamp);

                // Mark ourselves as speaking
                {
                    std::lock_guard<std::mutex> lock(m_speakingMutex);
                    m_speakingPlayers[m_cid] = std::chrono::steady_clock::now();
                }

                if (encodedPackets == 1) {
                    //g_logger.info("First voice packet sent!");
                }
            }
        }
    }

    // Process jitter buffers for smooth playback
    processJitterBuffers();

    // Log stats every 5 seconds
    auto now = std::chrono::steady_clock::now();
    if (std::chrono::duration_cast<std::chrono::seconds>(now - lastLog).count() >= 5) {
        if (m_connected) {
            //g_logger.info(fmt::format("ProcessAudio stats: calls={}, captures={}, sent={}, muted={}",
                //callCount, captureSuccess, encodedPackets, m_muted ? "yes" : "no"));
        }
        lastLog = now;
        callCount = 0;
        captureSuccess = 0;
        encodedPackets = 0;
    }
}

bool VoiceManager::captureAudio()
{
    static bool firstCapture = true;
    static bool loggedNotReady = false;
    static int checkCount = 0;
    static int readyCount = 0;
    static auto lastStatusLog = std::chrono::steady_clock::now();
    
    if (!m_waveIn || !m_audioCaptureInitialized) {
        if (!loggedNotReady) {
            g_logger.warning("Audio capture not initialized!");
            loggedNotReady = true;
        }
        return false;
    }
    
    checkCount++;
    
    // Check if we have data available
    if (m_waveHeader.dwFlags & WHDR_DONE) {
        readyCount++;
        
        // Copy captured data from WaveIn buffer to capture buffer
        std::lock_guard<std::mutex> lock(m_audioMutex);
        memcpy(m_captureBuffer.data(), m_waveInBuffer.data(), FRAME_SIZE * sizeof(int16_t));
        
        // Re-add the buffer for next capture
        MMRESULT result = waveInAddBuffer(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
        if (result != MMSYSERR_NOERROR) {
            char errorMsg[256];
            waveInGetErrorText(result, errorMsg, sizeof(errorMsg));
            g_logger.error(fmt::format("Failed to re-add wave buffer: {}", errorMsg));
        }
        
        if (firstCapture) {
            //g_logger.info(fmt::format("First audio buffer captured! Flags: 0x{:X}, Size: {} bytes", 
               // m_waveHeader.dwFlags, m_waveHeader.dwBytesRecorded));
            firstCapture = false;
        }
        
        return true;
    }
    
    // Log buffer status every 5 seconds
    auto now = std::chrono::steady_clock::now();
    if (std::chrono::duration_cast<std::chrono::seconds>(now - lastStatusLog).count() >= 5) {
        //g_logger.info(fmt::format("Audio capture status: checks={}, ready={}, flags=0x{:X}", 
           // checkCount, readyCount, m_waveHeader.dwFlags));
        lastStatusLog = now;
        checkCount = 0;
        readyCount = 0;
    }
    
    return false;
}

std::vector<uint8_t> VoiceManager::encodeAudio(const std::vector<int16_t>& pcmData)
{
    if (!m_encoder || pcmData.size() != FRAME_SIZE) {
        return {};
    }
    
    std::vector<uint8_t> opusData(MAX_PACKET_SIZE);
    int encodedSize = opus_encode(m_encoder, pcmData.data(), FRAME_SIZE, opusData.data(), MAX_PACKET_SIZE);
    
    if (encodedSize < 0) {
        g_logger.error(fmt::format("Opus encoding failed: {}", opus_strerror(encodedSize)));
        return {};
    }
    
    opusData.resize(encodedSize);
    return opusData;
}

void VoiceManager::sendVoicePacket(const std::vector<uint8_t>& opusData, uint32_t sequence, uint32_t timestamp)
{
    if (!m_socket || !m_socket->is_open() || !m_authenticated) {
        return;
    }
    
    // If test mode is enabled, queue packet for delayed playback
    if (m_testMode) {
        // Verify OpenAL is still valid before queueing test packets
        if (!m_audioContext || !m_audioSource) {
            g_logger.warning("Test mode is enabled but OpenAL is not initialized - disabling test mode");
            m_testMode = false;
            m_testThreadRunning = false;
        } else {
            std::lock_guard<std::mutex> lock(m_testQueueMutex);
            
            // Limit queue size to prevent memory issues
            if (m_testPacketQueue.size() >= 200) {
                static int warnCount = 0;
                if (++warnCount % 50 == 0) {
                    g_logger.warning(fmt::format("Test packet queue is full ({} packets), dropping oldest packets", m_testPacketQueue.size()));
                }
                // Drop oldest packets to make room
                while (m_testPacketQueue.size() >= 150) {
                    m_testPacketQueue.pop();
                }
            }
            
            DelayedPacket delayedPacket;
            delayedPacket.opusData = opusData;
            delayedPacket.sequence = sequence;
            delayedPacket.timestamp = timestamp;
            // Schedule playback 2 seconds from now
            delayedPacket.playbackTime = std::chrono::steady_clock::now() + std::chrono::seconds(2);
            
            m_testPacketQueue.push(delayedPacket);
            
            static int logCount = 0;
            if (++logCount % 20 == 0) {  // Log every 20 packets instead of every packet
                //g_logger.info(fmt::format("Queued test packet for playback in 2 seconds (queue size: {})", m_testPacketQueue.size()));
            }
        }
    }
    
    std::vector<uint8_t> packet = createPacket(opusData, sequence, timestamp);
    sendPacket(packet);
}

void VoiceManager::receivePackets()
{
    //g_logger.info("Voice receive thread started with synchronous socket");

    auto authStart = std::chrono::steady_clock::now();
    auto lastStatusLog = std::chrono::steady_clock::now();
    bool authTimeout = false;
    std::vector<uint8_t> buffer(8192);
    int consecutiveErrors = 0;
    const int MAX_CONSECUTIVE_ERRORS = 5;
    int loopCount = 0;

    while (!m_shouldStop) {
        loopCount++;

        // Log status every 5 seconds after authentication
        if (m_authenticated) {
            auto now = std::chrono::steady_clock::now();
            if (std::chrono::duration_cast<std::chrono::seconds>(now - lastStatusLog).count() >= 5) {
                //g_logger.info(fmt::format("Voice receive thread still running (loops: {}, errors: {})",
                    //loopCount, consecutiveErrors));
                lastStatusLog = now;
            }
        }
        // Check if socket is still valid
        if (!m_socket || !m_socket->is_open()) {
            // Socket closed - attempt auto-reconnect
            if (!m_shouldStop && !m_leaving && m_authenticated) {
                attemptReconnect();
            }
            break;
        }

        // Check for authentication timeout
        if (!m_authenticated && !authTimeout) {
            auto elapsed = std::chrono::steady_clock::now() - authStart;
            if (elapsed > std::chrono::seconds(10)) {
                g_logger.error("Authentication timeout - no response from server");
                authTimeout = true;
                m_shouldStop = true;
                break;
            }
        }

        try {
            // Set non-blocking mode
            m_socket->non_blocking(true);

            // Try to read available data
            std::error_code ec;
            size_t bytesRead = m_socket->read_some(asio::buffer(buffer), ec);

            if (ec == asio::error::would_block || ec == asio::error::try_again) {
                // No data available, sleep and retry
                std::this_thread::sleep_for(std::chrono::milliseconds(10));
                consecutiveErrors = 0; // Reset error counter
                continue;
            }

            if (ec == asio::error::eof) {
                // Connection closed by server - attempt reconnect
                consecutiveErrors++;
                if (consecutiveErrors >= MAX_CONSECUTIVE_ERRORS) {
                    if (!m_shouldStop) {
                        g_logger.error("Socket closed by server (EOF) - connection lost");
                        if (!m_leaving && m_authenticated) {
                            attemptReconnect();
                        }
                    }
                    break;
                }
                // Retry - might be temporary
                g_logger.warning(fmt::format("Received EOF, attempt {}/{} - retrying...",
                    consecutiveErrors, MAX_CONSECUTIVE_ERRORS));
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
                continue;
            }

            if (ec) {
                // Real error occurred
                consecutiveErrors++;
                if (consecutiveErrors >= MAX_CONSECUTIVE_ERRORS) {
                    if (!m_shouldStop) {
                        g_logger.error(fmt::format("Socket read error (after {} consecutive errors): {}",
                            consecutiveErrors, ec.message()));
                        if (!m_leaving && m_authenticated) {
                            attemptReconnect();
                        }
                    }
                    break;
                }
                // Minor error, retry
                g_logger.warning(fmt::format("Socket error ({}/{}): {} - retrying...",
                    consecutiveErrors, MAX_CONSECUTIVE_ERRORS, ec.message()));
                std::this_thread::sleep_for(std::chrono::milliseconds(50));
                continue;
            }

            // Check for 0-byte read (EOF without error code)
            if (bytesRead == 0) {
                consecutiveErrors++;
                if (consecutiveErrors >= MAX_CONSECUTIVE_ERRORS) {
                    if (!m_shouldStop) {
                        g_logger.error("Received 0 bytes multiple times - connection may be closed");
                        if (!m_leaving && m_authenticated) {
                            attemptReconnect();
                        }
                    }
                    break;
                }
                // Just no data, sleep and retry
                std::this_thread::sleep_for(std::chrono::milliseconds(10));
                continue;
            }

            // Reset error counter on successful read
            consecutiveErrors = 0;

            if (bytesRead > 0) {
                // Append to receive buffer for framing
                m_recvBuffer.insert(m_recvBuffer.end(), buffer.begin(), buffer.begin() + bytesRead);

                // Check if this is a text message (auth response or relay control message)
                // Text messages start with '{' and are not framed
                if (!m_authenticated || (m_recvBuffer.size() > 0 && m_recvBuffer[0] == '{')) {
                    // Find end of JSON message
                    std::string textData(m_recvBuffer.begin(), m_recvBuffer.end());
                    size_t braceEnd = textData.find('}');
                    if (braceEnd != std::string::npos) {
                        std::string message = textData.substr(0, braceEnd + 1);
                        m_recvBuffer.erase(m_recvBuffer.begin(), m_recvBuffer.begin() + braceEnd + 1);

                        // Handle auth response
                        if (!m_authenticated && message.find("auth_result") != std::string::npos) {
                            if (message.find("\"success\":true") != std::string::npos) {
                                m_authenticated = true;
                            } else {
                                g_logger.error("Authentication rejected by relay server");
                                m_shouldStop = true;
                                break;
                            }
                            continue;
                        }

                        // Handle relay control messages (player_joined, player_left)
                        if (m_authenticated) {
                            handleRelayMessage(message);
                            continue;
                        }

                        // Old auth format compatibility
                        if (!m_authenticated && message.find("authenticated") != std::string::npos) {
                            m_authenticated = true;
                            continue;
                        }
                    } else if (m_recvBuffer.size() > 4096) {
                        // Too much data without JSON end, clear buffer
                        m_recvBuffer.clear();
                    }
                    continue;
                }

                // Process framed packets
                if (m_authenticated && !m_recvBuffer.empty()) {
                    // Try to unframe packets
                    auto packets = unframePacket(m_recvBuffer);

                    if (!packets.empty()) {
                        // Process each complete packet
                        for (const auto& pkt : packets) {
                            if (pkt.size() >= 30) { // Minimum voice packet size
                                try {
                                    receiveVoicePacket(pkt);
                                } catch (const std::exception& e) {
                                    g_logger.error(fmt::format("Exception processing voice packet: {}", e.what()));
                                }
                            }
                        }

                        // Calculate consumed bytes and keep remaining
                        size_t consumed = 0;
                        for (const auto& pkt : packets) {
                            consumed += 4 + pkt.size(); // 4-byte length prefix + data
                        }
                        if (consumed <= m_recvBuffer.size()) {
                            m_recvBuffer.erase(m_recvBuffer.begin(), m_recvBuffer.begin() + consumed);
                        } else {
                            m_recvBuffer.clear();
                        }
                    } else {
                        // No complete packets yet, wait for more data
                        // But limit buffer size to prevent memory issues
                        if (m_recvBuffer.size() > 65536) {
                            g_logger.warning(fmt::format("Receive buffer too large ({} bytes), clearing", m_recvBuffer.size()));
                            m_recvBuffer.clear();
                        }
                    }
                }
            }

        } catch (const std::exception& e) {
            consecutiveErrors++;
            if (consecutiveErrors >= MAX_CONSECUTIVE_ERRORS) {
                if (!m_shouldStop) {
                    g_logger.error(fmt::format("Error receiving voice packet (after {} consecutive errors): {}",
                        consecutiveErrors, e.what()));
                    if (!m_leaving && m_authenticated) {
                        attemptReconnect();
                    }
                }
                break;
            }
            // Minor exception, retry
            g_logger.warning(fmt::format("Minor receive error (attempt {}/{}): {}",
                consecutiveErrors, MAX_CONSECUTIVE_ERRORS, e.what()));
            std::this_thread::sleep_for(std::chrono::milliseconds(50));
        } catch (...) {
            if (!m_shouldStop) {
                g_logger.error("Unknown exception in receive thread");
            }
            break;
        }
    }

    //g_logger.info(fmt::format("Voice receive thread stopped (authenticated: {})", m_authenticated ? "yes" : "no"));
}

void VoiceManager::receiveVoicePacket(const std::vector<uint8_t>& data)
{
    static int totalReceived = 0;
    static int totalPlayed = 0;
    static auto lastLog = std::chrono::steady_clock::now();

    totalReceived++;

    if (data.size() < 30) { // Minimum packet size
        g_logger.warning(fmt::format("Received packet too small: {} bytes (minimum 30)", data.size()));
        return;
    }

    try {
        VoicePacket packet = parsePacket(data);

        // Check if packet is from a different client
        if (packet.senderCid != m_cid) {
            // Mark player as speaking
            {
                std::lock_guard<std::mutex> lock(m_speakingMutex);
                m_speakingPlayers[packet.senderCid] = std::chrono::steady_clock::now();
            }

            // Decode audio
            std::vector<int16_t> pcmData = decodeAudio(packet.payload);
            if (!pcmData.empty()) {
                totalPlayed++;

                // Add to jitter buffer instead of playing immediately
                std::lock_guard<std::mutex> lock(m_jitterMutex);
                auto& jitterQueue = m_jitterBuffers[packet.senderCid];
                JitterBufferEntry entry;
                entry.pcmData = pcmData;
                entry.senderCid = packet.senderCid;
                entry.sequence = packet.sequence;
                entry.arrivalTime = std::chrono::steady_clock::now();
                jitterQueue.push_back(entry);

                // Limit jitter buffer size
                while (jitterQueue.size() > JITTER_MAX_ENTRIES) {
                    jitterQueue.erase(jitterQueue.begin());
                }

                static std::set<uint32_t> loggedSenders;
                if (loggedSenders.find(packet.senderCid) == loggedSenders.end()) {
                    //g_logger.info(fmt::format("Receiving voice from CID {} (payload: {} bytes, decoded: {} samples)",
                        //packet.senderCid, packet.payload.size(), pcmData.size()));
                    loggedSenders.insert(packet.senderCid);
                }
            } else {
                g_logger.warning(fmt::format("Failed to decode audio from CID {} (payload size: {})",
                    packet.senderCid, packet.payload.size()));
            }
        } else {
            // This is our own packet - NEVER play it (prevents echo)
            static int echoCount = 0;
            if (++echoCount == 1) {
                //g_logger.info(fmt::format("Received our own packet back (CID {}) - ignoring to prevent echo", m_cid));
            }
        }

        // Log stats every 5 seconds
        auto now = std::chrono::steady_clock::now();
        if (std::chrono::duration_cast<std::chrono::seconds>(now - lastLog).count() >= 5) {
            //g_logger.info(fmt::format("Voice RX stats: received={}, played={}", totalReceived, totalPlayed));
            lastLog = now;
            totalReceived = 0;
            totalPlayed = 0;
        }
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Exception processing voice packet: {}", e.what()));
    }
}

VoiceManager::VoicePacket VoiceManager::parsePacket(const std::vector<uint8_t>& data)
{
    VoicePacket packet;
    size_t offset = 0;
    
    // Parse header
    packet.version = data[offset++];
    
    // Parse room ID (16 bytes)
    std::string roomId;
    for (int i = 0; i < 16; ++i) {
        if (data[offset + i] != 0) {
            roomId += static_cast<char>(data[offset + i]);
        }
    }
    packet.roomId = roomId;
    offset += 16;
    
    // Parse sender CID (4 bytes, network byte order)
    packet.senderCid = (data[offset] << 24) | (data[offset + 1] << 16) | (data[offset + 2] << 8) | data[offset + 3];
    offset += 4;
    
    // Parse sequence (4 bytes, network byte order)
    packet.sequence = (data[offset] << 24) | (data[offset + 1] << 16) | (data[offset + 2] << 8) | data[offset + 3];
    offset += 4;
    
    // Parse timestamp (4 bytes, network byte order)
    packet.timestamp = (data[offset] << 24) | (data[offset + 1] << 16) | (data[offset + 2] << 8) | data[offset + 3];
    offset += 4;
    
    // Parse flags
    packet.flags = data[offset++];
    
    // Parse payload
    packet.payload.assign(data.begin() + offset, data.end());
    
    return packet;
}

std::vector<uint8_t> VoiceManager::createPacket(const std::vector<uint8_t>& opusData, uint32_t sequence, uint32_t timestamp)
{
    std::vector<uint8_t> packet;
    packet.reserve(30 + opusData.size());
    
    // Version
    packet.push_back(PROTOCOL_VERSION);
    
    // Room ID (16 bytes, encode room name)
    std::string roomId = m_roomId;
    if (roomId.length() > 16) {
        roomId = roomId.substr(0, 16); // Truncate if too long
    }
    
    // Copy room name to packet
    for (int i = 0; i < 16; ++i) {
        if (i < roomId.length()) {
            packet.push_back(roomId[i]);
        } else {
            packet.push_back(0); // Pad with zeros
        }
    }
    
    // Sender CID (4 bytes, network byte order)
    packet.push_back((m_cid >> 24) & 0xFF);
    packet.push_back((m_cid >> 16) & 0xFF);
    packet.push_back((m_cid >> 8) & 0xFF);
    packet.push_back(m_cid & 0xFF);
    
    // Sequence (4 bytes, network byte order)
    packet.push_back((sequence >> 24) & 0xFF);
    packet.push_back((sequence >> 16) & 0xFF);
    packet.push_back((sequence >> 8) & 0xFF);
    packet.push_back(sequence & 0xFF);
    
    // Timestamp (4 bytes, network byte order)
    packet.push_back((timestamp >> 24) & 0xFF);
    packet.push_back((timestamp >> 16) & 0xFF);
    packet.push_back((timestamp >> 8) & 0xFF);
    packet.push_back(timestamp & 0xFF);
    
    // Flags
    packet.push_back(0);
    
    // Payload
    packet.insert(packet.end(), opusData.begin(), opusData.end());
    
    return packet;
}

void VoiceManager::sendPacket(const std::vector<uint8_t>& data)
{
    if (m_socket && m_socket->is_open()) {
        try {
            // Frame packet: 4-byte length prefix + data
            auto framed = framePacket(data);
            asio::write(*m_socket, asio::buffer(framed));
        } catch (const std::exception& e) {
            g_logger.error(fmt::format("Failed to send voice packet: {}", e.what()));
        }
    }
}

void VoiceManager::sendControlMessage(const std::string& message)
{
    if (m_socket && m_socket->is_open()) {
        try {
            asio::write(*m_socket, asio::buffer(message));
        } catch (const std::exception& e) {
            g_logger.error(fmt::format("Failed to send control message: {}", e.what()));
        }
    }
}

std::vector<uint8_t> VoiceManager::framePacket(const std::vector<uint8_t>& data)
{
    std::vector<uint8_t> framed;
    uint32_t len = static_cast<uint32_t>(data.size());
    framed.reserve(4 + data.size());
    // Big-endian 4-byte length prefix
    framed.push_back((len >> 24) & 0xFF);
    framed.push_back((len >> 16) & 0xFF);
    framed.push_back((len >> 8) & 0xFF);
    framed.push_back(len & 0xFF);
    framed.insert(framed.end(), data.begin(), data.end());
    return framed;
}

std::vector<std::vector<uint8_t>> VoiceManager::unframePacket(const std::vector<uint8_t>& data)
{
    std::vector<std::vector<uint8_t>> packets;
    size_t offset = 0;

    while (offset + 4 <= data.size()) {
        uint32_t len = (data[offset] << 24) | (data[offset + 1] << 16) |
                       (data[offset + 2] << 8) | data[offset + 3];
        offset += 4;

        if (len == 0 || len > MAX_PACKET_SIZE + 100 || offset + len > data.size()) {
            // Invalid length or incomplete packet - might be a text message (JSON)
            // If it starts with '{', treat the whole remaining data as text
            if (offset > 4 && data[offset - 4] == '{') {
                // This is likely a JSON text message, not framed
                break;
            }
            // Reset and treat remaining as raw (for backward compat with auth response)
            break;
        }

        packets.emplace_back(data.begin() + offset, data.begin() + offset + len);
        offset += len;
    }

    return packets;
}

void VoiceManager::handleRelayMessage(const std::string& message)
{
    // Handle JSON control messages from relay (player_joined, player_left, etc.)
    try {
        // Simple JSON parsing for known messages
        if (message.find("player_joined") != std::string::npos) {
            // Extract cid from JSON
            size_t cidPos = message.find("\"cid\":");
            if (cidPos != std::string::npos) {
                uint32_t cid = 0;
                sscanf(message.c_str() + cidPos, "\"cid\":%u", &cid);
                if (cid > 0 && cid != m_cid) {
                    std::lock_guard<std::mutex> lock(m_connectedPlayersMutex);
                    if (std::find(m_connectedPlayers.begin(), m_connectedPlayers.end(), cid) == m_connectedPlayers.end()) {
                        m_connectedPlayers.push_back(cid);
                    }
                }
            }
        } else if (message.find("player_left") != std::string::npos) {
            size_t cidPos = message.find("\"cid\":");
            if (cidPos != std::string::npos) {
                uint32_t cid = 0;
                sscanf(message.c_str() + cidPos, "\"cid\":%u", &cid);
                if (cid > 0) {
                    std::lock_guard<std::mutex> lock(m_connectedPlayersMutex);
                    m_connectedPlayers.erase(
                        std::remove(m_connectedPlayers.begin(), m_connectedPlayers.end(), cid),
                        m_connectedPlayers.end());
                    std::lock_guard<std::mutex> mutedLock(m_mutedPlayersMutex);
                    m_mutedPlayers.erase(cid);
                }
            }
        } else if (message.find("player_muted") != std::string::npos) {
            size_t cidPos = message.find("\"cid\":");
            size_t mutedPos = message.find("\"muted\":");
            if (cidPos != std::string::npos && mutedPos != std::string::npos) {
                uint32_t cid = 0;
                sscanf(message.c_str() + cidPos, "\"cid\":%u", &cid);
                bool muted = message.find("\"muted\":true") != std::string::npos;
                if (cid > 0) {
                    std::lock_guard<std::mutex> lock(m_mutedPlayersMutex);
                    if (muted)
                        m_mutedPlayers.insert(cid);
                    else
                        m_mutedPlayers.erase(cid);
                }
            }
        } else if (message.find("auth_result") != std::string::npos) {
            if (message.find("\"success\":true") != std::string::npos) {
                m_authenticated = true;
            }
        }
    } catch (...) {
        // Ignore JSON parse errors
    }
}

std::vector<int16_t> VoiceManager::decodeAudio(const std::vector<uint8_t>& opusData)
{
    if (!m_decoder) {
        static int noDecoderCount = 0;
        if (noDecoderCount++ % 100 == 0) {
            g_logger.error(fmt::format("Cannot decode audio: decoder not initialized (count: {})", noDecoderCount));
        }
        return {};
    }
    
    if (opusData.empty()) {
        static int emptyDataCount = 0;
        if (emptyDataCount++ % 100 == 0) {
            g_logger.warning(fmt::format("Cannot decode audio: empty opus data (count: {})", emptyDataCount));
        }
        return {};
    }
    
    std::vector<int16_t> pcmData(FRAME_SIZE);
    int decodedSize = opus_decode(m_decoder, opusData.data(), opusData.size(), pcmData.data(), FRAME_SIZE, 0);
    
    if (decodedSize < 0) {
        static int decodeErrorCount = 0;
        if (decodeErrorCount++ % 50 == 0) {
            g_logger.error(fmt::format("Opus decoding failed: {} (error count: {}, opus data size: {})", 
                opus_strerror(decodedSize), decodeErrorCount, opusData.size()));
        }
        return {};
    }
    
    static int decodeSuccessCount = 0;
    if (++decodeSuccessCount == 1) {
        //g_logger.info(fmt::format("First audio packet decoded successfully: {} samples from {} bytes", 
            //decodedSize, opusData.size()));
    }
    
    pcmData.resize(decodedSize);
    return pcmData;
}

void VoiceManager::setPlayerVolume(uint32_t cid, float volume)
{
    m_playerVolumes[cid] = std::max(0.0f, std::min(1.0f, volume));
}

float VoiceManager::getPlayerVolume(uint32_t cid) const
{
    auto it = m_playerVolumes.find(cid);
    return it != m_playerVolumes.end() ? it->second : 1.0f;
}

void VoiceManager::playAudio(const std::vector<int16_t>& pcmData, uint32_t senderCid)
{
    if (pcmData.empty()) {
        return;
    }
    
    if (!m_audioContext || !m_audioSource) {
        static int errorCount = 0;
        if (errorCount++ % 100 == 0) {
            g_logger.error(fmt::format("Cannot play audio: OpenAL not initialized (context={}, source={}) - error #{}",
                static_cast<void*>(m_audioContext), m_audioSource, errorCount));
        }
        return;
    }
    
    // Verify OpenAL context is current (but don't be too aggressive about it)
    ALCcontext* currentContext = alcGetCurrentContext();
    if (currentContext != m_audioContext) {
        static int restoreCount = 0;
        if (restoreCount++ == 0) {
            g_logger.warning("OpenAL context is not current, attempting to restore...");
        }
        if (!alcMakeContextCurrent(m_audioContext)) {
            static int failCount = 0;
            if (failCount++ % 100 == 0) {
                g_logger.error(fmt::format("Failed to restore OpenAL context - cannot play audio (fail #{})", failCount));
            }
            return;
        }
        if (restoreCount == 1) {
            //g_logger.info("OpenAL context restored successfully");
        }
    }
    
    std::lock_guard<std::mutex> lock(m_playbackMutex);
    
    // Get and apply volume for this player, multiplied by master volume
    float playerVol = senderCid > 0 ? getPlayerVolume(senderCid) : 1.0f;
    float volume = playerVol * m_masterVolume;
    
    static int playAttempts = 0;
    static int bufferCreations = 0;
    static int bufferReuses = 0;
    static int playSuccesses = 0;
    playAttempts++;
    
    // First, check for processed buffers and return them to available queue
    ALint processed = 0;
    alGetSourcei(m_audioSource, AL_BUFFERS_PROCESSED, &processed);
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        g_logger.error(fmt::format("Failed to query processed buffers (error: 0x{:X})", error));
        return;
    }
    
    if (processed > 0) {
        ALuint processedBuffers[16];
        int toUnqueue = std::min(processed, 16);
        alSourceUnqueueBuffers(m_audioSource, toUnqueue, processedBuffers);
        error = alGetError();
        if (error != AL_NO_ERROR) {
            g_logger.error(fmt::format("Failed to unqueue buffers (error: 0x{:X})", error));
        } else {
            for (int i = 0; i < toUnqueue; ++i) {
                m_availableBuffers.push(processedBuffers[i]);
            }
            static int recycleCount = 0;
            if (++recycleCount % 50 == 0) {
                //g_logger.info(fmt::format("Recycled {} buffers (total available: {})", toUnqueue, m_availableBuffers.size()));
            }
        }
    }
    
    // Get an available buffer
    ALuint buffer = 0;
    if (!m_availableBuffers.empty()) {
        buffer = m_availableBuffers.front();
        m_availableBuffers.pop();
        bufferReuses++;
        if (bufferReuses == 1) {
            //g_logger.info("First buffer reuse successful");
        }
    } else {
        // Limit to 32 buffers maximum
        static int totalBuffersCreated = 0;
        if (totalBuffersCreated >= 32) {
            // Too many buffers, skip this audio packet
            static int dropCount = 0;
            if (++dropCount % 50 == 0) {
                g_logger.warning(fmt::format("Dropped {} audio packets (no buffers available, created: {})", 
                    dropCount, totalBuffersCreated));
            }
            return;
        }
        
        // Clear any previous errors
        alGetError();
        
        // Create a new buffer if none available
        alGenBuffers(1, &buffer);
        error = alGetError();
        if (error != AL_NO_ERROR || buffer == 0) {
            g_logger.error(fmt::format("Failed to create OpenAL buffer (error: 0x{:X}, buffer ID: {}, total created: {})", 
                error, buffer, totalBuffersCreated));
            return;
        }
        totalBuffersCreated++;
        bufferCreations++;
        if (totalBuffersCreated <= 5) {
            //g_logger.info(fmt::format("Created OpenAL buffer #{} (ID: {})", totalBuffersCreated, buffer));
        }
    }
    
    // Verify buffer is valid before using it
    if (buffer == 0 || !alIsBuffer(buffer)) {
        g_logger.error(fmt::format("Invalid buffer ID: {}", buffer));
        return;
    }
    
    // Clear any previous errors
    alGetError();
    
    // Upload audio data to buffer
    alBufferData(buffer, AL_FORMAT_MONO16, pcmData.data(), 
                 pcmData.size() * sizeof(int16_t), SAMPLE_RATE);
    
    error = alGetError();
    if (error != AL_NO_ERROR) {
        g_logger.error(fmt::format("Failed to upload audio data to buffer (error: 0x{:X}, buffer: {})", error, buffer));
        // Return buffer to pool instead of leaking it
        m_availableBuffers.push(buffer);
        return;
    }
    
    // Apply volume before queueing (set source gain)
    alSourcef(m_audioSource, AL_GAIN, volume);
    error = alGetError();
    if (error != AL_NO_ERROR) {
        static int volumeErrorCount = 0;
        if (volumeErrorCount++ % 100 == 0) {
            g_logger.error(fmt::format("Failed to set volume (error: 0x{:X})", error));
        }
    }
    
    // Queue buffer to source
    alSourceQueueBuffers(m_audioSource, 1, &buffer);
    error = alGetError();
    if (error != AL_NO_ERROR) {
        g_logger.error(fmt::format("Failed to queue buffer to source (error: 0x{:X})", error));
        m_availableBuffers.push(buffer);
        return;
    }
    
    // Start playing if not already
    ALint state;
    alGetSourcei(m_audioSource, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING) {
        alSourcePlay(m_audioSource);
        error = alGetError();
        if (error != AL_NO_ERROR) {
            g_logger.error(fmt::format("Failed to start audio playback (error: 0x{:X})", error));
        } else {
            static int startCount = 0;
            if (++startCount <= 3) {
                //g_logger.info(fmt::format("Started audio playback (start #{}) with volume {:.2f}", startCount, volume));
            }
        }
    }
    
    playSuccesses++;
    if (playSuccesses % 100 == 0) {
        //g_logger.info(fmt::format("Playback stats: attempts={}, created={}, reused={}, success={}", 
            //playAttempts, bufferCreations, bufferReuses, playSuccesses));
    }
}

bool VoiceManager::verifyToken(const std::string& token)
{
    if (token.empty()) {
        return false;
    }

    // Simple token verification: accept any non-empty token
    // The TFS generates tokens as: playerId-roomName-secret
    // The relay server does its own auth check
    // Full HMAC verification can be added later when TFS generates proper HMAC tokens
    return true;
}

std::string VoiceManager::generateHmac(const std::string& data, const std::string& secret)
{
    // Use OpenSSL HMAC-SHA256 for real implementation
    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int hashLen;
    
    HMAC(EVP_sha256(), secret.c_str(), secret.length(),
         reinterpret_cast<const unsigned char*>(data.c_str()), data.length(),
         hash, &hashLen);
    
    // Convert to hex string
    std::string result;
    result.reserve(hashLen * 2);
    for (unsigned int i = 0; i < hashLen; ++i) {
        char hex[3];
        snprintf(hex, sizeof(hex), "%02x", hash[i]);
        result += hex;
    }
    
    return result;
}

std::string VoiceManager::generateHmacBinary(const std::string& data, const std::string& secret)
{
    // Use OpenSSL HMAC-SHA256 for real implementation
    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int hashLen;
    
    HMAC(EVP_sha256(), secret.c_str(), secret.length(),
         reinterpret_cast<const unsigned char*>(data.c_str()), data.length(),
         hash, &hashLen);
    
    // Return binary HMAC (to match PHP's hash_hmac with true parameter)
    return std::string(reinterpret_cast<char*>(hash), hashLen);
}

// Windows API audio capture initialization
bool VoiceManager::initializeAudioCapture()
{
    WAVEFORMATEX waveFormat;
    waveFormat.wFormatTag = WAVE_FORMAT_PCM;
    waveFormat.nChannels = CHANNELS;
    waveFormat.nSamplesPerSec = SAMPLE_RATE;
    waveFormat.wBitsPerSample = 16;
    waveFormat.nBlockAlign = (waveFormat.nChannels * waveFormat.wBitsPerSample) / 8;
    waveFormat.nAvgBytesPerSec = waveFormat.nSamplesPerSec * waveFormat.nBlockAlign;
    waveFormat.cbSize = 0;

    MMRESULT result = waveInOpen(&m_waveIn, WAVE_MAPPER, &waveFormat, 0, 0, CALLBACK_NULL);
    if (result != MMSYSERR_NOERROR) {
        char errorMsg[256];
        waveInGetErrorText(result, errorMsg, sizeof(errorMsg));
        g_logger.error(fmt::format("Failed to open audio input device: {}", errorMsg));
        return false;
    }

    // Allocate dedicated buffer for WaveIn
    m_waveInBuffer.resize(FRAME_SIZE);
    
    // Prepare wave header
    ZeroMemory(&m_waveHeader, sizeof(WAVEHDR));
    m_waveHeader.lpData = (LPSTR)m_waveInBuffer.data();
    m_waveHeader.dwBufferLength = FRAME_SIZE * sizeof(int16_t);
    m_waveHeader.dwFlags = 0;

    result = waveInPrepareHeader(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
    if (result != MMSYSERR_NOERROR) {
        g_logger.error("Failed to prepare wave header");
        waveInClose(m_waveIn);
        m_waveIn = nullptr;
        return false;
    }

    // Add buffer and start recording
    result = waveInAddBuffer(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
    if (result != MMSYSERR_NOERROR) {
        g_logger.error("Failed to add wave buffer");
        waveInUnprepareHeader(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
        waveInClose(m_waveIn);
        m_waveIn = nullptr;
        return false;
    }

    result = waveInStart(m_waveIn);
    if (result != MMSYSERR_NOERROR) {
        char errorMsg[256];
        waveInGetErrorText(result, errorMsg, sizeof(errorMsg));
        g_logger.error(fmt::format("Failed to start wave input: {} (code: {})", errorMsg, result));
        waveInUnprepareHeader(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
        waveInClose(m_waveIn);
        m_waveIn = nullptr;
        return false;
    }

    m_audioCaptureInitialized = true;
    //g_logger.info(fmt::format("Audio capture initialized successfully - Buffer size: {} bytes, Frame size: {} samples", 
       // FRAME_SIZE * sizeof(int16_t), FRAME_SIZE));
    //g_logger.info(fmt::format("Audio format: {} Hz, {} channels, 16-bit PCM", SAMPLE_RATE, CHANNELS));
    return true;
}

void VoiceManager::cleanupAudioCapture()
{
    if (m_waveIn) {
        try {
            // Stop and cleanup wave input
            waveInStop(m_waveIn);
            waveInReset(m_waveIn);
            waveInUnprepareHeader(m_waveIn, &m_waveHeader, sizeof(WAVEHDR));
            waveInClose(m_waveIn);
        } catch (...) {
            g_logger.warning("Exception during audio capture cleanup");
        }
        m_waveIn = nullptr;
    }
    
    if (m_audioCaptureInitialized) {
        m_audioCaptureInitialized = false;
    }
}

// OpenAL initialization
bool VoiceManager::initializeOpenAL()
{
    //g_logger.info("Initializing OpenAL for voice playback...");
    
    // Open audio device
    m_audioDevice = alcOpenDevice(nullptr);
    if (!m_audioDevice) {
        g_logger.error("Failed to open OpenAL device");
        return false;
    }
    //g_logger.info(fmt::format("OpenAL device opened: %p", m_audioDevice));
    
    // Create audio context
    m_audioContext = alcCreateContext(m_audioDevice, nullptr);
    if (!m_audioContext) {
        g_logger.error("Failed to create OpenAL context");
        alcCloseDevice(m_audioDevice);
        m_audioDevice = nullptr;
        return false;
    }
    //g_logger.info(fmt::format("OpenAL context created: %p", m_audioContext));
    
    // Make context current
    if (!alcMakeContextCurrent(m_audioContext)) {
        g_logger.error("Failed to make OpenAL context current");
        alcDestroyContext(m_audioContext);
        alcCloseDevice(m_audioDevice);
        m_audioContext = nullptr;
        m_audioDevice = nullptr;
        return false;
    }
    //g_logger.info("OpenAL context made current");
    
    // Generate audio source
    alGenSources(1, &m_audioSource);
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        g_logger.error(fmt::format("Failed to generate OpenAL source (error: 0x{:X})", error));
        cleanupOpenAL();
        return false;
    }
    //g_logger.info(fmt::format("OpenAL source generated: {}", m_audioSource));
    
    // Set source properties
    alSourcef(m_audioSource, AL_PITCH, 1.0f);
    alSourcef(m_audioSource, AL_GAIN, 1.0f);
    alSource3f(m_audioSource, AL_POSITION, 0.0f, 0.0f, 0.0f);
    alSource3f(m_audioSource, AL_VELOCITY, 0.0f, 0.0f, 0.0f);
    alSourcei(m_audioSource, AL_LOOPING, AL_FALSE);
    
    //g_logger.info(fmt::format("OpenAL initialized successfully! Context=%p, Device=%p, Source={}", 
       // m_audioContext, m_audioDevice, m_audioSource));
    return true;
}

void VoiceManager::cleanupOpenAL()
{
    try {
        if (m_audioSource) {
            alDeleteSources(1, &m_audioSource);
            m_audioSource = 0;
        }
        
        // Delete any remaining buffers
        while (!m_availableBuffers.empty()) {
            ALuint buffer = m_availableBuffers.front();
            m_availableBuffers.pop();
            alDeleteBuffers(1, &buffer);
        }
        
        if (m_audioContext) {
            alcMakeContextCurrent(nullptr);
            alcDestroyContext(m_audioContext);
            m_audioContext = nullptr;
        }
        
        if (m_audioDevice) {
            alcCloseDevice(m_audioDevice);
            m_audioDevice = nullptr;
        }
    } catch (...) {
        g_logger.warning("Exception during OpenAL cleanup");
    }
}

// Voice channel management functions
bool VoiceManager::joinChannel(VoiceChannelType type, const std::string& channelId, const std::string& password)
{
    if (m_connected) {
        leaveChannel();
    }
    
    m_currentChannelType = type;
    m_currentChannelId = channelId;
    
    // For now, use the existing join method with channel-specific room names
    std::string roomName;
    switch (type) {
        case VoiceChannelType::WORLD:
            roomName = "world_" + channelId;
            break;
        case VoiceChannelType::PARTY:
            roomName = "party_" + channelId;
            break;
        case VoiceChannelType::GUILD:
            roomName = "guild_" + channelId;
            break;
        case VoiceChannelType::PRIVATE:
            roomName = "private_" + channelId;
            break;
    }
    
    // Note: This method is for internal channel management
    // Actual joining should be done through the main join() method with proper token
    g_logger.warning("joinChannel() called without proper token - use main join() method instead");
    return false;
}

void VoiceManager::leaveChannel()
{
    if (m_connected) {
        leave();
    }
    m_currentChannelType = VoiceChannelType::WORLD;
    m_currentChannelId = "";
}

void VoiceManager::createPrivateChannel(const std::string& name, const std::string& password)
{
    std::string channelId = "private_" + std::to_string(m_cid) + "_" + std::to_string(std::time(nullptr));
    
    VoiceChannel channel;
    channel.type = VoiceChannelType::PRIVATE;
    channel.channelId = channelId;
    channel.name = name;
    channel.password = password;
    channel.creatorId = m_cid;
    channel.hasPassword = !password.empty();
    
    m_availableChannels[channelId] = channel;
    
    // Join the created channel
    joinChannel(VoiceChannelType::PRIVATE, channelId, password);
}

void VoiceManager::updatePlayerVolumes()
{
    // This would be called periodically to update volume multipliers
    // based on distance and channel type
    for (auto& [playerId, volume] : m_playerVolumes) {
        // Update volume based on distance and channel rules
        volume = calculateVolumeMultiplier(playerId, m_currentChannelId);
    }
}

float VoiceManager::calculateVolumeMultiplier(uint32_t playerId, const std::string& channelId)
{
    // Simplified volume calculation
    // In a real implementation, this would calculate based on:
    // - Distance between players (for WORLD channel)
    // - Channel type (PARTY/GUILD have no distance limit)
    // - Private channel settings
    
    switch (m_currentChannelType) {
        case VoiceChannelType::WORLD:
            // Distance-based volume: decrease by 20% every 5 SQM
            // This is a placeholder - real implementation would use player positions
            return 1.0f;
            
        case VoiceChannelType::PARTY:
        case VoiceChannelType::GUILD:
        case VoiceChannelType::PRIVATE:
            // No distance-based volume decrease
            return 1.0f;
            
        default:
            return 0.0f;
    }
}

std::vector<VoiceManager::VoiceChannel> VoiceManager::getAvailableChannels()
{
    std::vector<VoiceChannel> channels;
    for (const auto& [id, channel] : m_availableChannels) {
        channels.push_back(channel);
    }
    return channels;
}

// Test mode implementation
bool VoiceManager::enableTest()
{
    if (m_testMode) {
        //g_logger.info("Test mode already enabled");
        return true;
    }
    
    // Check if OpenAL is initialized
    if (!m_audioContext || !m_audioSource) {
        g_logger.error("Cannot enable test mode: OpenAL not initialized. Join a voice room first!");
        return false;
    }
    
    //g_logger.info("Enabling voice test mode - your voice will echo back after 2 seconds");
    m_testMode = true;
    m_testThreadRunning = true;
    
    // Start test playback thread
    m_testPlaybackThread = std::thread([this]() {
        processTestPackets();
    });
    
    return true;
}

void VoiceManager::disableTest()
{
    if (!m_testMode) {
        return;
    }
    
    //g_logger.info("Disabling voice test mode");
    m_testMode = false;
    m_testThreadRunning = false;
    
    // Wait for test thread to finish
    if (m_testPlaybackThread.joinable()) {
        try {
            m_testPlaybackThread.join();
        } catch (const std::exception& e) {
            g_logger.error(fmt::format("Error joining test thread: {}", e.what()));
        }
    }
    
    // Clear any pending test packets
    std::lock_guard<std::mutex> lock(m_testQueueMutex);
    while (!m_testPacketQueue.empty()) {
        m_testPacketQueue.pop();
    }
}

void VoiceManager::processTestPackets()
{
    //g_logger.info("Test playback thread started");

    try {
        while (m_testThreadRunning) {
            // Check if OpenAL is still valid
            if (!m_audioContext || !m_audioSource) {
                g_logger.warning("OpenAL context invalid, stopping test playback thread");
                m_testMode = false;
                m_testThreadRunning = false;
                break;
            }

            std::this_thread::sleep_for(std::chrono::milliseconds(100));

            auto now = std::chrono::steady_clock::now();

            std::lock_guard<std::mutex> lock(m_testQueueMutex);

            // Process packets that are ready to play
            while (!m_testPacketQueue.empty()) {
                const auto& packet = m_testPacketQueue.front();

                if (now >= packet.playbackTime) {
                    // Decode and play the audio
                    try {
                        std::vector<int16_t> pcmData = decodeAudio(packet.opusData);
                        if (!pcmData.empty()) {
                            playAudio(pcmData);
                        }
                    } catch (const std::exception& e) {
                        g_logger.error(fmt::format("Error playing test packet: {}", e.what()));
                    }

                    m_testPacketQueue.pop();
                } else {
                    // Next packet is not ready yet
                    break;
                }
            }
        }
    } catch (const std::exception& e) {
        g_logger.error(fmt::format("Test playback thread error: {}", e.what()));
    }

    //g_logger.info("Test playback thread stopped");
}

// Speaking indicator implementation
bool VoiceManager::isPlayerSpeaking(uint32_t cid) const
{
    std::lock_guard<std::mutex> lock(const_cast<std::mutex&>(m_speakingMutex));
    auto it = m_speakingPlayers.find(cid);
    if (it == m_speakingPlayers.end()) return false;

    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::steady_clock::now() - it->second).count();
    return elapsed < SPEAKING_TIMEOUT_MS;
}

std::vector<uint32_t> VoiceManager::getSpeakingPlayers() const
{
    std::vector<uint32_t> speaking;
    std::lock_guard<std::mutex> lock(const_cast<std::mutex&>(m_speakingMutex));
    auto now = std::chrono::steady_clock::now();
    for (const auto& [cid, time] : m_speakingPlayers) {
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - time).count();
        if (elapsed < SPEAKING_TIMEOUT_MS) {
            speaking.push_back(cid);
        }
    }
    return speaking;
}

// Connected players implementation
std::vector<uint32_t> VoiceManager::getConnectedPlayers() const
{
    std::lock_guard<std::mutex> lock(const_cast<std::mutex&>(m_connectedPlayersMutex));
    return m_connectedPlayers;
}

std::vector<uint32_t> VoiceManager::getMutedPlayers() const
{
    std::lock_guard<std::mutex> lock(const_cast<std::mutex&>(m_mutedPlayersMutex));
    return std::vector<uint32_t>(m_mutedPlayers.begin(), m_mutedPlayers.end());
}

void VoiceManager::clearConnectedPlayers()
{
    std::lock_guard<std::mutex> lock(const_cast<std::mutex&>(m_connectedPlayersMutex));
    m_connectedPlayers.clear();
}

// Auto-reconnect implementation
void VoiceManager::attemptReconnect()
{
    if (m_reconnecting || m_leaving || m_shouldStop) return;

    m_reconnecting = true;
    m_reconnectAttempts++;

    // Exponential backoff: 1s, 2s, 4s, 8s, 16s, max 30s
    int delayMs = std::min(1000 * (1 << (m_reconnectAttempts - 1)), 30000);
    g_logger.info(fmt::format("Attempting reconnect #{} in {} ms...", (int)m_reconnectAttempts, delayMs));

    std::thread([this, delayMs]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(delayMs));

        if (m_shouldStop || m_leaving) {
            m_reconnecting = false;
            return;
        }

        // Try to reconnect
        if (connectToRelay(m_relayHost, m_relayPort)) {
            // Re-send auth
            std::string authMessage = "{\"token\":\"" + m_token + "\",\"room\":\"" + m_roomId + "\",\"cid\":" + std::to_string(m_cid) + "}";
            try {
                asio::write(*m_socket, asio::buffer(authMessage));
            } catch (...) {}

            m_connected = true;
            m_authenticated = false;
            m_shouldStop = false;
            m_reconnecting = false;
            m_reconnectAttempts = 0;

            // Start new receive thread
            m_recvBuffer.clear();
            m_receiveThread = std::thread(&VoiceManager::receivePackets, this);
            g_logger.info("Voice reconnected successfully!");
        } else {
            m_reconnecting = false;
            // Will retry on next receive thread exit
        }
    }).detach();
}

// Jitter buffer implementation
void VoiceManager::processJitterBuffers()
{
    std::lock_guard<std::mutex> lock(m_jitterMutex);
    auto now = std::chrono::steady_clock::now();

    for (auto& [cid, queue] : m_jitterBuffers) {
        if (queue.empty()) continue;

        // Play packets that have been in the buffer for >= JITTER_BUFFER_MS
        while (!queue.empty()) {
            const auto& entry = queue.front();
            auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                now - entry.arrivalTime).count();

            if (elapsed >= JITTER_BUFFER_MS) {
                // Play this packet
                playAudio(entry.pcmData, entry.senderCid);
                queue.erase(queue.begin());
            } else {
                // Not ready yet
                break;
            }
        }
    }

    // Clean up empty jitter buffers
    for (auto it = m_jitterBuffers.begin(); it != m_jitterBuffers.end(); ) {
        if (it->second.empty()) {
            it = m_jitterBuffers.erase(it);
        } else {
            ++it;
        }
    }

    // Clean up stale speaking indicators
    {
        std::lock_guard<std::mutex> speakLock(m_speakingMutex);
        for (auto it = m_speakingPlayers.begin(); it != m_speakingPlayers.end(); ) {
            auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                now - it->second).count();
            if (elapsed > SPEAKING_TIMEOUT_MS * 3) {
                it = m_speakingPlayers.erase(it);
            } else {
                ++it;
            }
        }
    }
}
