/*
 * Copyright (c) 2010-2024 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "framework/core/application.h"
#if defined(WIN32) && defined(CRASH_HANDLER)

#include "crashhandler.h"
#include <framework/global.h>

#include <windows.h>
#include <winsock2.h>
#include <csignal>
#include <exception>
#include <atomic>
#include <thread>
#include <new.h>
#include <stdlib.h>

#ifdef _MSC_VER

#pragma warning (push)
#pragma warning (disable:4091) // warning C4091: 'typedef ': ignored on left of '' when no variable is declared
#include <imagehlp.h>
#pragma warning (pop)

#else

#include <imagehlp.h>

#endif

// minidumpapiset.h declares MiniDumpWriteDump and its types; it can coexist
// with imagehlp.h (unlike dbghelp.h which redefines the same structs)
#include <minidumpapiset.h>

#include <framework/core/graphicalapplication.h>

const char* getExceptionName(const DWORD exceptionCode)
{
    switch (exceptionCode) {
        case EXCEPTION_ACCESS_VIOLATION:         return "Access violation";
        case EXCEPTION_DATATYPE_MISALIGNMENT:    return "Datatype misalignment";
        case EXCEPTION_BREAKPOINT:               return "Breakpoint";
        case EXCEPTION_SINGLE_STEP:              return "Single step";
        case EXCEPTION_ARRAY_BOUNDS_EXCEEDED:    return "Array bounds exceeded";
        case EXCEPTION_FLT_DENORMAL_OPERAND:     return "Float denormal operand";
        case EXCEPTION_FLT_DIVIDE_BY_ZERO:       return "Float divide by zero";
        case EXCEPTION_FLT_INEXACT_RESULT:       return "Float inexact result";
        case EXCEPTION_FLT_INVALID_OPERATION:    return "Float invalid operation";
        case EXCEPTION_FLT_OVERFLOW:             return "Float overflow";
        case EXCEPTION_FLT_STACK_CHECK:          return "Float stack check";
        case EXCEPTION_FLT_UNDERFLOW:            return "Float underflow";
        case EXCEPTION_INT_DIVIDE_BY_ZERO:       return "Integer divide by zero";
        case EXCEPTION_INT_OVERFLOW:             return "Integer overflow";
        case EXCEPTION_PRIV_INSTRUCTION:         return "Privileged instruction";
        case EXCEPTION_IN_PAGE_ERROR:            return "In page error";
        case EXCEPTION_ILLEGAL_INSTRUCTION:      return "Illegal instruction";
        case EXCEPTION_NONCONTINUABLE_EXCEPTION: return "Noncontinuable exception";
        case EXCEPTION_STACK_OVERFLOW:           return "Stack overflow";
        case EXCEPTION_INVALID_DISPOSITION:      return "Invalid disposition";
        case EXCEPTION_GUARD_PAGE:               return "Guard page";
        case EXCEPTION_INVALID_HANDLE:           return "Invalid handle";
    }
    return "Unknown exception";
}

void Stacktrace(const CONTEXT* context, std::stringstream& ss)
{
    STACKFRAME sf;
    HANDLE process, thread;
    ULONG_PTR dwModBase, Disp;
    BOOL more = FALSE;
    DWORD machineType;
    int count = 0;
    char modname[MAX_PATH];
    char symBuffer[sizeof(IMAGEHLP_SYMBOL) + 255];

    auto* pSym = (PIMAGEHLP_SYMBOL)symBuffer;

    ZeroMemory(&sf, sizeof(sf));
#ifdef _WIN64
    sf.AddrPC.Offset = context->Rip;
    sf.AddrStack.Offset = context->Rsp;
    sf.AddrFrame.Offset = context->Rbp;
    machineType = IMAGE_FILE_MACHINE_AMD64;
#else
    sf.AddrPC.Offset = context->Eip;
    sf.AddrStack.Offset = context->Esp;
    sf.AddrFrame.Offset = context->Ebp;
    machineType = IMAGE_FILE_MACHINE_I386;
#endif

    sf.AddrPC.Mode = AddrModeFlat;
    sf.AddrStack.Mode = AddrModeFlat;
    sf.AddrFrame.Mode = AddrModeFlat;

    process = GetCurrentProcess();
    thread = GetCurrentThread();

    while (true) {
        more = StackWalk(machineType, process, thread, &sf, const_cast<CONTEXT*>(context), nullptr, SymFunctionTableAccess, SymGetModuleBase, nullptr);
        if (!more || sf.AddrFrame.Offset == 0)
            break;

        dwModBase = SymGetModuleBase(process, sf.AddrPC.Offset);
        if (dwModBase)
            GetModuleFileName(reinterpret_cast<HINSTANCE>(dwModBase), modname, MAX_PATH);
        else
            strcpy(modname, "Unknown");

        Disp = 0;
        pSym->SizeOfStruct = sizeof(symBuffer);
        pSym->MaxNameLength = 254;

        if (SymGetSymFromAddr(process, sf.AddrPC.Offset, &Disp, pSym))
            ss << fmt::format("    {}: {}({}+%#0lx) [0x%016lX]\n", count, modname, pSym->Name, Disp, sf.AddrPC.Offset);
        else
            ss << fmt::format("    {}: {} [0x%016lX]\n", count, modname, sf.AddrPC.Offset);
        ++count;
    }
}

std::string getExecutableDir()
{
    char path[MAX_PATH];
    DWORD len = GetModuleFileNameA(nullptr, path, MAX_PATH);
    if (len == 0 || len >= MAX_PATH)
        return {};
    std::string dir(path, len);
    const auto pos = dir.find_last_of("\\/");
    if (pos == std::string::npos)
        return {};
    return dir.substr(0, pos);
}

std::string buildReportHeader()
{
    return fmt::format(
        "== application crashed\n"
        "app name: {}\n"
        "app version: {}\n"
        "build compiler: {} - {}\n"
        "build date: {}\n"
        "build type: {}\n"
        "build revision: {} ({})\n"
        "crash date: {}\n"
        "module base: 0x{:016X}\n",
        g_app.getName(),
        g_app.getVersion(),
        g_app.getBuildCompiler(), g_app.getBuildArch(),
        g_app.getBuildDate(),
        g_app.getBuildType(),
        g_app.getBuildRevision(), g_app.getBuildCommit(),
        stdext::date_time_string(),
        reinterpret_cast<std::uintptr_t>(GetModuleHandle(nullptr))
    );
}

void writeMinidump(EXCEPTION_POINTERS* exceptionPointers)
{
    const std::string exeDir = getExecutableDir();
    const std::string baseDir = !exeDir.empty() ? exeDir : ".";

    const std::string fileName = fmt::format("{}\\crashdump-{}.dmp", baseDir, GetCurrentProcessId());
    HANDLE hFile = CreateFileA(fileName.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hFile == INVALID_HANDLE_VALUE)
        return;

    MINIDUMP_EXCEPTION_INFORMATION mei{};
    mei.ThreadId = GetCurrentThreadId();
    mei.ExceptionPointers = exceptionPointers;
    mei.ClientPointers = FALSE;

    MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), hFile,
        static_cast<MINIDUMP_TYPE>(MiniDumpWithIndirectlyReferencedMemory | MiniDumpScanMemory),
        exceptionPointers ? &mei : nullptr, nullptr, nullptr);

    CloseHandle(hFile);
}

void writeCrashReport(const std::string& report, EXCEPTION_POINTERS* exceptionPointers)
{
    g_logger.info(report);

    writeMinidump(exceptionPointers);

    // write next to the executable so it is found regardless of working directory
    const std::string exeDir = getExecutableDir();

    std::vector<std::string> dirs;
    if (!exeDir.empty())
        dirs.push_back(exeDir);

    char cwd[MAX_PATH];
    DWORD len = GetCurrentDirectory(sizeof(cwd), cwd);
    if (len > 0 && len < sizeof(cwd)) {
        std::string cwdStr(cwd, len);
        if (cwdStr != exeDir)
            dirs.push_back(cwdStr);
    }
    if (dirs.empty())
        dirs.push_back(".");

    std::string savedTo;
    for (const auto& dir : dirs) {
        const std::string fileName = fmt::format("{}\\crashreport.log", dir);
        std::ofstream fout(fileName, std::ios::out | std::ios::app);
        if (fout.is_open()) {
            fout << report;
            fout.close();
            if (savedTo.empty())
                savedTo = fileName;
            g_logger.info("Crash report saved to file {}", fileName);
        }
    }

    std::string msg = "The application has crashed.\n\n";
    if (!savedTo.empty())
        msg += fmt::format("A crash report has been written to:\n{}", savedTo);
    else
        msg += "Failed to write a crash report file.";
    MessageBoxA(nullptr, msg.c_str(), "Application crashed", MB_OK | MB_ICONERROR);
}

LONG CALLBACK ExceptionHandler(const LPEXCEPTION_POINTERS e)
{
    SymInitialize(GetCurrentProcess(), nullptr, TRUE);

    std::string crashReport = buildReportHeader();
    crashReport += fmt::format(
        "exception: {} (0x{:08X})\n"
        "exception address: 0x{:08X}\n"
        "  backtrace:\n",
        getExceptionName(e->ExceptionRecord->ExceptionCode), e->ExceptionRecord->ExceptionCode,
        reinterpret_cast<std::uintptr_t>(e->ExceptionRecord->ExceptionAddress)
    );

    std::stringstream oss;
    oss << crashReport;
    Stacktrace(e->ContextRecord, oss);
    oss << "\n";

    SymCleanup(GetCurrentProcess());

    writeCrashReport(oss.str(), e);

    return EXCEPTION_CONTINUE_SEARCH;
}

// std::terminate() / abort() end in __fastfail which bypasses the unhandled
// exception filter entirely - only these handlers see the crash before death.
void TerminateHandler()
{
    std::string reason;
    if (auto eptr = std::current_exception()) {
        try {
            std::rethrow_exception(eptr);
        } catch (const std::exception& e) {
            reason = fmt::format("std::terminate called, uncaught std::exception: {}", e.what());
        } catch (...) {
            reason = "std::terminate called, uncaught non-std::exception";
        }
    } else {
        reason = "std::terminate called with no active exception (e.g. joinable std::thread destroyed)";
    }

    SymInitialize(GetCurrentProcess(), nullptr, TRUE);

    CONTEXT context;
    RtlCaptureContext(&context);

    std::stringstream oss;
    oss << buildReportHeader();
    oss << "exception: " << reason << "\n";
    oss << "  backtrace:\n";
    Stacktrace(&context, oss);
    oss << "\n";

    SymCleanup(GetCurrentProcess());

    EXCEPTION_RECORD record{};
    record.ExceptionCode = 0xC0000409;
    record.ExceptionAddress = reinterpret_cast<PVOID>(context.Rip);
    EXCEPTION_POINTERS ep{};
    ep.ExceptionRecord = &record;
    ep.ContextRecord = &context;

    writeCrashReport(oss.str(), &ep);

    // skip our own SIGABRT handler, then continue the default terminate path
    signal(SIGABRT, SIG_DFL);
    std::abort();
}

void SignalHandler(int sig)
{
    signal(sig, SIG_DFL); // avoid recursion if we re-fault inside this handler
    SymInitialize(GetCurrentProcess(), nullptr, TRUE);

    CONTEXT context;
    RtlCaptureContext(&context);

    const char* sigName = "unknown signal";
    switch (sig) {
        case SIGABRT: sigName = "SIGABRT (abort)"; break;
        case SIGFPE:  sigName = "SIGFPE (floating point error)"; break;
        case SIGILL:  sigName = "SIGILL (illegal instruction)"; break;
        case SIGTERM: sigName = "SIGTERM"; break;
        case SIGINT:  sigName = "SIGINT"; break;
    }

    std::stringstream oss;
    oss << buildReportHeader();
    oss << "exception: fatal signal " << sigName << "\n";
    oss << "  backtrace:\n";
    Stacktrace(&context, oss);
    oss << "\n";

    SymCleanup(GetCurrentProcess());

    EXCEPTION_RECORD record{};
    record.ExceptionCode = 0xC0000409;
    record.ExceptionAddress = reinterpret_cast<PVOID>(context.Rip);
    EXCEPTION_POINTERS ep{};
    ep.ExceptionRecord = &record;
    ep.ContextRecord = &context;

    writeCrashReport(oss.str(), &ep);

    std::abort();
}

void PurecallHandler()
{
    SymInitialize(GetCurrentProcess(), nullptr, TRUE);

    CONTEXT context;
    RtlCaptureContext(&context);

    std::stringstream oss;
    oss << buildReportHeader();
    oss << "exception: pure virtual function call\n";
    oss << "  backtrace:\n";
    Stacktrace(&context, oss);
    oss << "\n";

    SymCleanup(GetCurrentProcess());

    EXCEPTION_RECORD record{};
    record.ExceptionCode = 0xC0000409;
    record.ExceptionAddress = reinterpret_cast<PVOID>(context.Rip);
    EXCEPTION_POINTERS ep{};
    ep.ExceptionRecord = &record;
    ep.ContextRecord = &context;

    writeCrashReport(oss.str(), &ep);
}

void InvalidParameterHandler(const wchar_t* expression, const wchar_t* function, const wchar_t* file, unsigned int line, uintptr_t)
{
    SymInitialize(GetCurrentProcess(), nullptr, TRUE);

    CONTEXT context;
    RtlCaptureContext(&context);

    std::stringstream oss;
    oss << buildReportHeader();
    oss << "exception: invalid CRT parameter\n";
    if (expression)
        oss << "  expression: " << stdext::utf16_to_utf8(expression) << "\n";
    if (function)
        oss << "  function: " << stdext::utf16_to_utf8(function) << "\n";
    if (file)
        oss << "  file: " << stdext::utf16_to_utf8(file) << ":" << line << "\n";
    oss << "  backtrace:\n";
    Stacktrace(&context, oss);
    oss << "\n";

    SymCleanup(GetCurrentProcess());

    EXCEPTION_RECORD record{};
    record.ExceptionCode = 0xC0000409;
    record.ExceptionAddress = reinterpret_cast<PVOID>(context.Rip);
    EXCEPTION_POINTERS ep{};
    ep.ExceptionRecord = &record;
    ep.ContextRecord = &context;

    writeCrashReport(oss.str(), &ep);
}

// ---------------------------------------------------------------------------
// Hang watchdog: the main loop calls updateMainHeartbeat() every frame and the
// map/event loop calls updateMapHeartbeat() every iteration. If either stops
// for more than HANG_MS while the app is running, the watchdog writes a hang
// report + minidump so freezes can be diagnosed offline. Watching both matters:
// a frozen main loop leaves the screen dead, while a dead event loop leaves a
// "live-looking" but frozen game (the symptom that motivated this watchdog).
// ---------------------------------------------------------------------------
namespace {
    std::atomic<uint64_t> g_mainHeartbeat{ 0 };
    std::atomic<uint64_t> g_mapHeartbeat{ 0 };
    constexpr uint64_t HANG_MS = 10000;
    constexpr uint64_t WATCHDOG_PERIOD_MS = 2000;
}

void updateMainHeartbeat()
{
    g_mainHeartbeat.store(GetTickCount64(), std::memory_order_relaxed);
}

void updateMapHeartbeat()
{
    g_mapHeartbeat.store(GetTickCount64(), std::memory_order_relaxed);
}

void writeHangReport(const char* loopName, uint64_t lastBeat, uint64_t now)
{
    const std::string exeDir = getExecutableDir();
    const std::string baseDir = !exeDir.empty() ? exeDir : ".";

    std::string report = buildReportHeader();
    report += fmt::format("exception: {} loop unresponsive for {} ms (hang detected by watchdog)\n", loopName, now - lastBeat);

    // write the text report first so detection is recorded even if the dump
    // write below stalls or takes a long time
    const std::string txtName = fmt::format("{}\\hangreport.txt", baseDir);
    std::ofstream fout(txtName, std::ios::out | std::ios::app);
    if (fout.is_open()) {
        fout << report << "\n";
        fout.close();
    }

    const std::string dmpName = fmt::format("{}\\hangdump-{}.dmp", baseDir, GetCurrentProcessId());
    HANDLE hFile = CreateFileA(dmpName.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hFile != INVALID_HANDLE_VALUE) {
        // small dump: thread list + stacks is enough to symbolicate the stall,
        // avoids the multi-GB full-memory dumps that took minutes to write
        MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), hFile,
            static_cast<MINIDUMP_TYPE>(MiniDumpNormal | MiniDumpWithThreadInfo),
            nullptr, nullptr, nullptr);
        CloseHandle(hFile);
    }

    g_logger.error("{} loop hang detected ({} ms) - wrote {} and {}", loopName, now - lastBeat, txtName, dmpName);
}

void HangWatchdogThread()
{
    while (true) {
        Sleep(WATCHDOG_PERIOD_MS);

        if (!g_app.isRunning() || g_app.isStopping()) {
            g_mainHeartbeat.store(0, std::memory_order_relaxed);
            g_mapHeartbeat.store(0, std::memory_order_relaxed);
            continue;
        }

        const uint64_t now = GetTickCount64();

        const uint64_t lastMain = g_mainHeartbeat.load(std::memory_order_relaxed);
        if (lastMain != 0 && now - lastMain > HANG_MS) {
            writeHangReport("main", lastMain, now);
            // re-arm: only report again if the loop recovered and stalled again
            g_mainHeartbeat.store(now, std::memory_order_relaxed);
        }

        const uint64_t lastMap = g_mapHeartbeat.load(std::memory_order_relaxed);
        if (lastMap != 0 && now - lastMap > HANG_MS) {
            writeHangReport("event/map", lastMap, now);
            g_mapHeartbeat.store(now, std::memory_order_relaxed);
        }
    }
}

void installCrashHandler()
{
    SetUnhandledExceptionFilter(ExceptionHandler);
    std::set_terminate(TerminateHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGILL, SignalHandler);
    _set_purecall_handler(PurecallHandler);
    _set_invalid_parameter_handler(InvalidParameterHandler);

    std::thread(HangWatchdogThread).detach();
}

#endif
