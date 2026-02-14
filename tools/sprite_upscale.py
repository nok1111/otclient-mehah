"""
Sprite Upscaling Pipeline for OTClient (Single-Pass)
=====================================================
Reads .spr -> decodes each sprite -> upscales 2x in memory -> writes .cwm
No intermediate files, no disk thrashing.

Usage:
  python sprite_upscale.py
"""

import struct
import sys
import io
import time
from pathlib import Path
from PIL import Image

# ============ CONFIGURATION ============
SPR_FILE = r"..\data\things\1098\Tibia.spr"
CWM_OUTPUT = r"..\data\things\1098\Tibia.cwm"
SPRITE_SIZE = 32
TARGET_SIZE = 64
USE_U32_COUNT = True     # True for protocol >= 960
USE_ALPHA = False        # True if GameSpritesAlphaChannel
CHANNELS = 4 if USE_ALPHA else 3
# =======================================

def read_u16(f): return struct.unpack('<H', f.read(2))[0]
def read_u32(f): return struct.unpack('<I', f.read(4))[0]


def decode_sprite(f, addr):
    """Decode a single sprite from .spr at the given address. Returns RGBA Image or None."""
    if addr == 0:
        return None

    f.seek(addr)
    f.read(3)  # skip color key
    pixel_data_size = read_u16(f)
    if pixel_data_size == 0:
        return None

    raw = f.read(pixel_data_size)
    pixels = bytearray(SPRITE_SIZE * SPRITE_SIZE * 4)
    offset = 0
    write_pos = 0
    max_write = SPRITE_SIZE * SPRITE_SIZE * 4
    has_visible = False

    while offset + 4 <= len(raw) and write_pos < max_write:
        transparent = raw[offset] | (raw[offset + 1] << 8)
        offset += 2
        colored = raw[offset] | (raw[offset + 1] << 8)
        offset += 2

        skip_bytes = transparent * 4
        if write_pos + skip_bytes > max_write:
            break
        write_pos += skip_bytes

        for _ in range(colored):
            if write_pos + 4 > max_write or offset + CHANNELS > len(raw):
                break
            pixels[write_pos] = raw[offset]
            pixels[write_pos + 1] = raw[offset + 1]
            pixels[write_pos + 2] = raw[offset + 2]
            pixels[write_pos + 3] = raw[offset + 3] if USE_ALPHA else 0xFF
            offset += CHANNELS
            write_pos += 4
            has_visible = True

    if not has_visible:
        return None

    return Image.frombytes('RGBA', (SPRITE_SIZE, SPRITE_SIZE), bytes(pixels))


def upscale_sprite(img):
    """Upscale sprite 2x: LANCZOS for RGB (smooth), NEAREST for alpha (sharp edges)."""
    r, g, b, a = img.split()
    rgb = Image.merge('RGB', (r, g, b)).resize((TARGET_SIZE, TARGET_SIZE), Image.LANCZOS)
    a_up = a.resize((TARGET_SIZE, TARGET_SIZE), Image.NEAREST)
    rr, gg, bb = rgb.split()
    return Image.merge('RGBA', (rr, gg, bb, a_up))


def sprite_to_png_bytes(img):
    """Convert PIL Image to PNG bytes in memory."""
    buf = io.BytesIO()
    img.save(buf, format='PNG', optimize=True)
    return buf.getvalue()


def main():
    spr_path = Path(__file__).parent / SPR_FILE
    cwm_path = Path(__file__).parent / CWM_OUTPUT

    print(f"=== OTClient Sprite Upscaler (Single-Pass) ===")
    print(f"Input:  {spr_path}")
    print(f"Output: {cwm_path}")
    print(f"Scale:  {SPRITE_SIZE}x{SPRITE_SIZE} -> {TARGET_SIZE}x{TARGET_SIZE}")
    print()

    # Phase 1: Read .spr and process all sprites in memory
    print("Reading .spr file...")
    with open(spr_path, 'rb') as f:
        signature = read_u32(f)
        sprites_count = read_u32(f) if USE_U32_COUNT else read_u16(f)
        offsets_start = f.tell()

        print(f"  Signature: 0x{signature:08X}")
        print(f"  Total sprite IDs: {sprites_count}")

        # Read all offsets at once
        offset_data = f.read(sprites_count * 4)
        offsets = struct.unpack(f'<{sprites_count}I', offset_data)

        # Process sprites: decode -> upscale -> PNG bytes
        # Store as dict: sprite_id -> png_bytes
        sprite_pngs = {}
        processed = 0
        skipped = 0
        start_time = time.time()

        for sprite_id in range(1, sprites_count + 1):
            addr = offsets[sprite_id - 1]
            img = decode_sprite(f, addr)

            if img is None:
                skipped += 1
                continue

            upscaled = upscale_sprite(img)
            png_data = sprite_to_png_bytes(upscaled)
            sprite_pngs[sprite_id] = png_data
            processed += 1

            if processed % 10000 == 0:
                elapsed = time.time() - start_time
                rate = processed / elapsed if elapsed > 0 else 0
                eta = (sprites_count - sprite_id) / rate / 60 if rate > 0 else 0
                print(f"  {processed} sprites processed ({sprite_id}/{sprites_count}) "
                      f"[{rate:.0f}/s, ETA: {eta:.1f}min]")

    elapsed = time.time() - start_time
    print(f"\nPhase 1 done: {processed} sprites in {elapsed:.0f}s ({processed/elapsed:.0f}/s)")
    print(f"  Skipped: {skipped} empty sprites")

    # Phase 2: Write .cwm file
    print(f"\nWriting CWM file ({processed} entries)...")
    max_id = max(sprite_pngs.keys()) if sprite_pngs else 0

    with open(cwm_path, 'wb') as f:
        # Header (CWM v2: u32 spritesCount instead of u16)
        f.write(struct.pack('<B', 0x02))        # version 2
        f.write(struct.pack('<I', max_id))       # spritesCount (u32)
        f.write(struct.pack('<I', processed))    # entries count

        # Build metadata + data
        sorted_ids = sorted(sprite_pngs.keys())
        current_offset = 0
        metadata_entries = []

        for sid in sorted_ids:
            png_data = sprite_pngs[sid]
            name = str(sid).encode('ascii')
            metadata_entries.append((current_offset, len(png_data), name))
            current_offset += len(png_data)

        # Write metadata
        for offset, size, name in metadata_entries:
            f.write(struct.pack('<I', offset))
            f.write(struct.pack('<I', size))
            f.write(struct.pack('<H', len(name)))
            f.write(name)

        # Write PNG data
        for sid in sorted_ids:
            f.write(sprite_pngs[sid])

    file_size_mb = cwm_path.stat().st_size / (1024 * 1024)
    total_time = time.time() - start_time
    print(f"\n=== DONE ===")
    print(f"CWM file: {cwm_path}")
    print(f"Size: {file_size_mb:.1f} MB")
    print(f"Sprites: {processed}")
    print(f"Total time: {total_time:.0f}s")
    print(f"\nNow set sprite size to {TARGET_SIZE} in your client config!")


if __name__ == '__main__':
    main()
