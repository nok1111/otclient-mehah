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

#include "texture.h"
#include "framebuffer.h"
#include "graphics.h"
#include "image.h"

#include <framework/core/application.h>
#include <framework/core/eventdispatcher.h>

#include "framework/core/graphicalapplication.h"

 // UINT16_MAX = just to avoid conflicts with GL generated ID.
static std::atomic_uint32_t UID(UINT16_MAX);

Texture::Texture() : m_uniqueId(UID.fetch_add(1)) { generateHash(); }
Texture::Texture(const Size& size) : m_uniqueId(UID.fetch_add(1))
{
    generateHash();
    if (!setupSize(size))
        return;

    createTexture();
    bind();
    setupPixels(0, size, nullptr, 4);
    setupWrap();
    setupFilters();
}

Texture::Texture(const ImagePtr& image, const bool buildMipmaps, const bool compress) : m_uniqueId(UID.fetch_add(1))
{
    generateHash();

    setProp(Prop::compress, compress);
    setProp(Prop::buildMipmaps, buildMipmaps);
    m_image = image;
    setupSize(image->getSize());
}

Texture::~Texture()
{
#ifndef NDEBUG
    assert(!g_app.isTerminated());
#endif
    if (g_graphics.ok() && m_id != 0) {
        g_mainDispatcher.addEvent([id = m_id] {
            glDeleteTextures(1, &id);
        });
    }
}

Texture* Texture::create()
{
    if (m_image) {
        createTexture();
        uploadPixels(m_image, getProp(buildMipmaps), getProp(compress));
        m_image = nullptr;
    }

    return this;
}

void Texture::updateImage(const ImagePtr& image) { m_image = image; setupSize(image->getSize()); }

void Texture::updatePixels(uint8_t* pixels, const int level, const int channels, const bool compress) {
    bind();
    setupPixels(level, m_size, pixels, channels, compress);
}
void Texture::uploadPixels(const ImagePtr& image, const bool buildMipmaps, const bool compress)
{
    if (!setupSize(image->getSize()))
        return;

    bind();

    uint_fast8_t level = 0;
    do {
        setupPixels(level++, image->getSize(), image->getPixelData(), image->getBpp(), compress);
    } while (buildMipmaps && image->nextMipmap());
    if (buildMipmaps) setProp(Prop::buildMipmaps, true);

    setupWrap();
    setupFilters();
}

void Texture::bind() { if (m_id) glBindTexture(GL_TEXTURE_2D, m_id); }

void Texture::buildHardwareMipmaps()
{
    if (getProp(hasMipMaps))
        return;

#ifndef OPENGL_ES
    if (!glGenerateMipmap)
        return;
#endif

    setProp(hasMipMaps, true);

    bind();
    setupFilters();
    glGenerateMipmap(GL_TEXTURE_2D);
}

void Texture::setSmooth(const bool smooth)
{
    if (smooth == getProp(Prop::smooth))
        return;

    setProp(Prop::smooth, smooth);
    if (!m_id) return;

    bind();
    setupFilters();
}

void Texture::setRepeat(const bool repeat)
{
    if (getProp(Prop::repeat) == repeat)
        return;

    setProp(Prop::repeat, repeat);
    if (!m_id) return;

    bind();
    setupWrap();
}

void Texture::setUpsideDown(const bool upsideDown)
{
    if (getProp(Prop::upsideDown) == upsideDown)
        return;

    setProp(Prop::upsideDown, upsideDown);
    setupTranformMatrix();
}

void Texture::createTexture()
{
    if (g_graphics.ok() && m_id != 0)
        glDeleteTextures(1, &m_id);

    glGenTextures(1, &m_id);
    assert(m_id != 0);

    generateHash();
}

bool Texture::setupSize(const Size& size)
{
    if (m_size == size)
        return true;

    // checks texture max size
    if (std::max<int>(size.width(), size.height()) > g_graphics.getMaxTextureSize()) {
        g_logger.error(stdext::format("loading texture with size %dx%d failed, "
                       "the maximum size allowed by the graphics card is %dx%d,"
                       "to prevent crashes the texture will be displayed as a blank texture",
                       size.width(), size.height(), g_graphics.getMaxTextureSize(), g_graphics.getMaxTextureSize()));
        return false;
    }

    m_size = size;

    setupTranformMatrix();

    return true;
}

void Texture::setupWrap() const
{
    const GLint texParam = getProp(repeat) ? GL_REPEAT : GL_CLAMP_TO_EDGE;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, texParam);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, texParam);
}

void Texture::setupFilters() const
{
    if (!m_id) return;

    GLenum minFilter;
    GLenum magFilter;
    if (getProp(smooth)) {
        minFilter = getProp(hasMipMaps) ? GL_LINEAR_MIPMAP_LINEAR : GL_LINEAR;
        magFilter = GL_LINEAR;
    } else {
        minFilter = getProp(hasMipMaps) ? GL_NEAREST_MIPMAP_NEAREST : GL_NEAREST;
        magFilter = GL_NEAREST;
    }
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
}

void Texture::setupTranformMatrix()
{
    static constexpr Size SIZE32x64(32, 64);
    static constexpr Size SIZE64x32(64, 32);
    static constexpr Size SIZE64x128(64, 128);
    static constexpr Size SIZE128x256(128, 256);
    static constexpr Size SIZE256x512(256, 512);
    static constexpr Size SIZE512x1024(512, 1024);

    static const auto MATRIX11x11_CACHED = toMatrix(11);
    static const auto MATRIX32x32_CACHED = toMatrix(32);
    static const auto MATRIX64x64_CACHED = toMatrix(64);
    static const auto MATRIX128x128_CACHED = toMatrix(128);
    static const auto MATRIX256x256_CACHED = toMatrix(256);
    static const auto MATRIX512x512_CACHED = toMatrix(512);

    static const auto MATRIX32x64_CACHED = toMatrix(SIZE32x64);
    static const auto MATRIX64x32_CACHED = toMatrix(SIZE64x32);
    static const auto MATRIX64x128_CACHED = toMatrix(SIZE64x128);
    static const auto MATRIX128x256_CACHED = toMatrix(SIZE128x256);
    static const auto MATRIX256x512_CACHED = toMatrix(SIZE256x512);
    static const auto MATRIX512x1024_CACHED = toMatrix(SIZE512x1024);

    if (getProp(upsideDown)) {
        m_transformMatrix = { 1.0f / m_size.width(), 0.0f,                                                  0.0f,
                              0.0f,                 -1.0f / m_size.height(),                                0.0f,
                              0.0f,                  m_size.height() / static_cast<float>(m_size.height()), 1.0f };
    } else {
        if (m_size == 11) m_transformMatrix = MATRIX11x11_CACHED;
        else if (m_size == 32) m_transformMatrix = MATRIX32x32_CACHED;
        else if (m_size == 64) m_transformMatrix = MATRIX64x64_CACHED;
        else if (m_size == 128) m_transformMatrix = MATRIX128x128_CACHED;
        else if (m_size == 256) m_transformMatrix = MATRIX256x256_CACHED;
        else if (m_size == 512) m_transformMatrix = MATRIX512x512_CACHED;
        else if (m_size == SIZE32x64) m_transformMatrix = MATRIX32x64_CACHED;
        else if (m_size == SIZE64x32) m_transformMatrix = MATRIX64x32_CACHED;
        else if (m_size == SIZE64x128) m_transformMatrix = MATRIX64x128_CACHED;
        else if (m_size == SIZE128x256) m_transformMatrix = MATRIX128x256_CACHED;
        else if (m_size == SIZE256x512) m_transformMatrix = MATRIX256x512_CACHED;
        else if (m_size == SIZE512x1024) m_transformMatrix = MATRIX512x1024_CACHED;
        else m_transformMatrix = toMatrix(m_size);
    }
}

void Texture::setupPixels(const int level, const Size& size, const uint8_t* pixels, const int channels, const bool compress) const
{
    GLenum format = 0;
    switch (channels) {
        case 4:
            format = GL_RGBA;
            break;
        case 3:
            format = GL_RGB;
            break;
        case 2:
            format = GL_LUMINANCE_ALPHA;
            break;
        case 1:
            format = GL_LUMINANCE;
            break;
    }

    GLenum internalFormat = GL_RGBA;

#ifdef OPENGL_ES
    //TODO
#else
    if (compress)
        internalFormat = GL_COMPRESSED_RGBA;
#endif

    glTexImage2D(GL_TEXTURE_2D, level, internalFormat, size.width(), size.height(), 0, format, GL_UNSIGNED_BYTE, pixels);
}

void Texture::loadTransparentPixels(const ImagePtr& image)
{
    if (image) {
        GLenum format = 0;
        switch (image->getBpp()) {
            case 4:
                format = GL_RGBA;
                break;
            case 3:
                format = GL_RGB;
                break;
            case 2:
                format = GL_LUMINANCE_ALPHA;
                break;
            case 1:
                format = GL_LUMINANCE;
                break;
        }
        uchar* pixels = image->getPixelData();
        const Size& size = image->getSize();
        // Iterate over all pixels, if its alpha is 0, set to 1 at linear pixel index
        if (format == GL_RGBA && pixels) {
            m_transparentPixels.resize(size.area(), 0);
            for (int y = 0; y < size.height(); ++y) {
                for (int x = 0; x < size.width(); ++x) {
                    int pixelIndex = (y * size.width() + x) * 4;
                    if (pixels[pixelIndex + 3] == 0) {
                        m_transparentPixels[pixelIndex / 4] = 1;
                    }
                }
            }
        }
    }
}