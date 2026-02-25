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
#include <obfuscate.h>

 // APPEARANCES
#define BYTES_IN_SPRITE_SHEET 384 * 384 * 4
#define LZMA_UNCOMPRESSED_SIZE BYTES_IN_SPRITE_SHEET + 122
#define LZMA_HEADER_SIZE LZMA_PROPS_SIZE + 8
#define SPRITE_SHEET_WIDTH_BYTES 384 * 4

// ENCRYPTION SYSTEM
// Enable client encryption
#define ENABLE_ENCRYPTION 0
// Enable client encryption maker/builder.
// You can compile it once and use this executable to only encrypt client files once with command --encrypt which will be using password below.
#define ENABLE_ENCRYPTION_BUILDER 0
// for security reasons make sure you are using password with at last 100+ characters
#define ENCRYPTION_PASSWORD AY_OBFUSCATE("sP9vK2nQ7xL4mT8rY1cD6hJ3uF0aW5eR2tG9bN4zX7qM1kV6pS3dH8jC5yU0iO2lA7wE4rT9uI1oP6sD3fG8hJ5kL0zX2cV7bN4mQ9")
// do not insert special characters in the header (ONLY UPPERCASE LETTERS, LOWERCASE LETTERS AND NUMBERS) | example: #define ENCRYPTION_HEADER AY_OBFUSCATE("21UsO5ARfRnIScs415BNMab")
#define ENCRYPTION_HEADER AY_OBFUSCATE("X7mQ2aL9vR4nK8tP1cD5hJ3uF6sB0wE")

// DISCORD RPC (https://discord.com/developers/applications)
// Enable Discord Rich Presence
#ifndef ENABLE_DISCORD_RPC
    #define ENABLE_DISCORD_RPC 0 // 1 to enable | 0 to disable
#endif
#define RPC_API_KEY "1060650448522051664" // Your API Key
// RPC Configs (https://youtu.be/zCHYtRlD58g) step by step to config your rich presence
#define SHOW_CHARACTER_NAME_RPC 1 // 1 to enable | 0 to disable
#define SHOW_CHARACTER_LEVEL_RPC 1 // 1 to enable | 0 to disable
#define SHOW_CHARACTER_WORLD_RPC 1 // 1 to enable | 0 to disable
#define OFFLINE_RPC_TEXT "Selecting Character..." // Message at client startup | offline character
#define STATE_RPC_TEXT "github.com/mehah/otclient" // State Text
#define RPC_LARGE_IMAGE "rpc-logo" // Large Image Name (Imported to API)
#define RPC_LARGE_TEXT "OTClient - Redemption" // Large Text (Text showed at tooltip large image)
