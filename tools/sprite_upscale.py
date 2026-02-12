"""
Sprite Upscaling Pipeline for OTClient
=======================================
1. Extract sprites from .spr to individual PNGs (32x32)
2. Upscale with Real-ESRGAN (32x32 -> 64x64)
3. Repack upscaled PNGs into .cwm format for OTClient HD sprites

Usage:
  python sprite_upscale.py extract   -- Extract .spr to PNGs
  python sprite_upscale.py upscale   -- Run Real-ESRGAN on extracted PNGs
  python sprite_upscale.py pack      -- Pack upscaled PNGs into .cwm
  python sprite_upscale.py all       -- Run full pipeline
"""

import struct
import sys
import os
import subprocess
import zipfile
import io
from pathlib import Path
from urllib.request import urlretrieve

# ============ CONFIGURATION ============
SPR_FILE = r"..\data\things\1098\Tibia.spr"
EXTRACT_DIR = "sprites_32"
UPSCALED_DIR = "sprites_64"
CWM_OUTPUT = r"..\data\things\1098\Tibia.cwm"
SPRITE_SIZE = 32
USE_U32_COUNT = True     # True for protocol >= 960
USE_ALPHA = False         # True if GameSpritesAlphaChannel
CHANNELS = 4 if USE_ALPHA else 3
ESRGAN_DIR = "realesrgan"
ESRGAN_URL = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-windows.zip"
# =======================================

def read_u8(f):
    return struct.unpack('<B', f.read(1))[0]

def read_u16(f):
    return struct.unpack('<H', f.read(2))[0]

def read_u32(f):
    return struct.unpack('<I', f.read(4))[0]

def write_u8(f, v):
    f.write(struct.pack('<B', v))

def write_u16(f, v):
    f.write(struct.pack('<H', v))

def write_u32(f, v):
    f.write(struct.pack('<I', v))


def extract_sprites():
    """Extract all sprites from .spr file to individual PNGs."""
    from PIL import Image

    spr_path = Path(__file__).parent / SPR_FILE
    out_dir = Path(__file__).parent / EXTRACT_DIR
    out_dir.mkdir(exist_ok=True)

    print(f"Reading {spr_path}...")
    with open(spr_path, 'rb') as f:
        signature = read_u32(f)
        sprites_count = read_u32(f) if USE_U32_COUNT else read_u16(f)
        offsets_start = f.tell()

        print(f"Signature: 0x{signature:08X}")
        print(f"Sprites: {sprites_count}")

        # Read all offsets
        offsets = []
        for i in range(sprites_count):
            offsets.append(read_u32(f))

        extracted = 0
        skipped = 0

        for sprite_id in range(1, sprites_count + 1):
            addr = offsets[sprite_id - 1]
            if addr == 0:
                skipped += 1
                continue

            f.seek(addr)
            # Skip 3-byte color key
            f.read(3)
            pixel_data_size = read_u16(f)

            if pixel_data_size == 0:
                skipped += 1
                continue

            raw = f.read(pixel_data_size)

            # Decode RLE
            pixels = bytearray(SPRITE_SIZE * SPRITE_SIZE * 4)
            offset = 0
            write_pos = 0
            max_write = SPRITE_SIZE * SPRITE_SIZE * 4

            while offset + 4 <= len(raw) and write_pos < max_write:
                transparent = raw[offset] | (raw[offset + 1] << 8)
                offset += 2
                colored = raw[offset] | (raw[offset + 1] << 8)
                offset += 2

                # Transparent pixels (RGBA = 0,0,0,0)
                skip_bytes = transparent * 4
                if write_pos + skip_bytes > max_write:
                    break
                write_pos += skip_bytes  # Already zeroed

                # Colored pixels
                for _ in range(colored):
                    if write_pos + 4 > max_write or offset + CHANNELS > len(raw):
                        break
                    r = raw[offset]
                    g = raw[offset + 1]
                    b = raw[offset + 2]
                    a = raw[offset + 3] if USE_ALPHA else 0xFF
                    offset += CHANNELS

                    pixels[write_pos] = r
                    pixels[write_pos + 1] = g
                    pixels[write_pos + 2] = b
                    pixels[write_pos + 3] = a
                    write_pos += 4

            # Create image
            img = Image.frombytes('RGBA', (SPRITE_SIZE, SPRITE_SIZE), bytes(pixels))

            # Skip fully transparent sprites
            if img.getextrema()[3][1] == 0:
                skipped += 1
                continue

            img.save(out_dir / f"{sprite_id}.png")
            extracted += 1

            if extracted % 1000 == 0:
                print(f"  Extracted {extracted} sprites...")

    print(f"Done! Extracted {extracted} sprites, skipped {skipped} empty. Output: {out_dir}")
    return extracted


def download_esrgan():
    """Download Real-ESRGAN portable if not present."""
    esrgan_path = Path(__file__).parent / ESRGAN_DIR
    exe_path = esrgan_path / "realesrgan-ncnn-vulkan.exe"

    if exe_path.exists():
        print(f"Real-ESRGAN already downloaded at {exe_path}")
        return exe_path

    esrgan_path.mkdir(exist_ok=True)
    zip_path = esrgan_path / "realesrgan.zip"

    print(f"Downloading Real-ESRGAN from GitHub...")
    urlretrieve(ESRGAN_URL, zip_path)

    print("Extracting...")
    with zipfile.ZipFile(zip_path, 'r') as z:
        z.extractall(esrgan_path)

    zip_path.unlink()

    if not exe_path.exists():
        # Check if extracted into a subfolder
        for p in esrgan_path.rglob("realesrgan-ncnn-vulkan.exe"):
            # Move contents up
            for item in p.parent.iterdir():
                item.rename(esrgan_path / item.name)
            break

    if not exe_path.exists():
        print("ERROR: Could not find realesrgan-ncnn-vulkan.exe after extraction")
        sys.exit(1)

    print(f"Real-ESRGAN ready at {exe_path}")
    return exe_path


def upscale_sprites():
    """Upscale extracted sprites using Real-ESRGAN."""
    exe_path = download_esrgan()
    input_dir = Path(__file__).parent / EXTRACT_DIR
    output_dir = Path(__file__).parent / UPSCALED_DIR
    output_dir.mkdir(exist_ok=True)

    if not input_dir.exists() or not list(input_dir.glob("*.png")):
        print("ERROR: No extracted sprites found. Run 'extract' first.")
        sys.exit(1)

    sprite_count = len(list(input_dir.glob("*.png")))
    print(f"Upscaling {sprite_count} sprites with Real-ESRGAN (2x)...")
    print("This may take a while depending on your GPU...")

    cmd = [
        str(exe_path),
        "-i", str(input_dir),
        "-o", str(output_dir),
        "-s", "2",                    # 2x scale: 32->64
        "-n", "realesrgan-x4plus",    # model (works well for pixel art)
        "-f", "png",
    ]

    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=False)

    if result.returncode != 0:
        print("WARNING: Real-ESRGAN returned non-zero exit code")

    upscaled = len(list(output_dir.glob("*.png")))
    print(f"Done! Upscaled {upscaled} sprites. Output: {output_dir}")
    return upscaled


def pack_cwm():
    """Pack upscaled PNG sprites into .cwm format."""
    input_dir = Path(__file__).parent / UPSCALED_DIR
    cwm_path = Path(__file__).parent / CWM_OUTPUT

    if not input_dir.exists() or not list(input_dir.glob("*.png")):
        print("ERROR: No upscaled sprites found. Run 'upscale' first.")
        sys.exit(1)

    # Collect all sprite PNGs
    sprites = {}
    for png_file in input_dir.glob("*.png"):
        try:
            sprite_id = int(png_file.stem)
            sprites[sprite_id] = png_file
        except ValueError:
            continue

    if not sprites:
        print("ERROR: No valid sprite PNGs found")
        sys.exit(1)

    max_id = max(sprites.keys())
    entries_count = len(sprites)

    print(f"Packing {entries_count} sprites into CWM (max ID: {max_id})...")

    # Read all PNG data
    sprite_data = {}
    for sprite_id, png_path in sorted(sprites.items()):
        with open(png_path, 'rb') as f:
            sprite_data[sprite_id] = f.read()

    # Build CWM file
    with open(cwm_path, 'wb') as f:
        # Header
        write_u8(f, 0x01)          # version
        write_u16(f, max_id)       # spritesCount (max sprite ID)
        write_u32(f, entries_count) # number of entries

        # Calculate offsets: data starts right after all metadata entries
        current_offset = 0
        metadata = []

        for sprite_id in sorted(sprite_data.keys()):
            png_bytes = sprite_data[sprite_id]
            name = str(sprite_id)
            metadata.append((current_offset, len(png_bytes), name))
            current_offset += len(png_bytes)

        # Write metadata
        for offset, size, name in metadata:
            write_u32(f, offset)
            write_u32(f, size)
            name_bytes = name.encode('ascii')
            write_u16(f, len(name_bytes))
            f.write(name_bytes)

        # Write PNG data
        for sprite_id in sorted(sprite_data.keys()):
            f.write(sprite_data[sprite_id])

    file_size_mb = cwm_path.stat().st_size / (1024 * 1024)
    print(f"Done! CWM file: {cwm_path} ({file_size_mb:.1f} MB)")
    print(f"\nIMPORTANT: Set sprite size to 64 in your client config!")


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(0)

    cmd = sys.argv[1].lower()

    if cmd == 'extract':
        extract_sprites()
    elif cmd == 'upscale':
        upscale_sprites()
    elif cmd == 'pack':
        pack_cwm()
    elif cmd == 'all':
        extract_sprites()
        upscale_sprites()
        pack_cwm()
    else:
        print(f"Unknown command: {cmd}")
        print(__doc__)
        sys.exit(1)


if __name__ == '__main__':
    main()
