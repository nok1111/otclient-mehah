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

#pragma once

#include "texture.h"
#include <framework/core/declarations.h>

class TextureManager
{
public:
    void init();
    void terminate();
    void poll();

    void clearCache();
    void liveReload();

    void preload(const std::string& fileName, const bool smooth = true) { getTexture(fileName, smooth); }
    TexturePtr getTexture(const std::string& fileName, bool smooth = true);
    const TexturePtr& getEmptyTexture() { return m_emptyTexture; }
    TexturePtr loadTexture(std::stringstream& file);
    void loadTextureTransparentPixels(const std::string& fileName);

private:
    std::unordered_map<std::string, TexturePtr> m_textures;
    std::vector<AnimatedTexturePtr> m_animatedTextures;
    TexturePtr m_emptyTexture;
    ScheduledEventPtr m_liveReloadEvent;
    std::shared_mutex m_mutex;

    friend class GarbageCollection;
};

extern TextureManager g_textures;
