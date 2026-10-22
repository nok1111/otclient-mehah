import struct, sys

PACKET = "tools_packet.bin"
OTB = "data/things/1098/items.otb"
OTB_SERVER = r"C:\Users\nokturno\Desktop\1.4 konakon\TFS-1.4.2-Compatible-Aura-Effect-Wings-Shader-MEHAH\data\items\items.otb"
DAT = "data/things/1098/Tibia.dat"

# ---------------- OTB (server flags per clientId) ----------------
def parse_otb(path):
    d = open(path, "rb").read()
    assert d[:4] in (b"OTBI", b"\0\0\0\0")
    # node tree: 0xFE type <props+children> 0xFF ; 0xFD escape
    pos = 4
    items = {}  # clientId -> dict

    def read_nodes(pos, depth=0):
        # returns list of (type, props_bytes, end_pos)
        nodes = []
        while pos < len(d):
            if d[pos] == 0xFF:
                return nodes, pos + 1
            if d[pos] != 0xFE:
                pos += 1
                continue
            ntype = d[pos + 1]
            p = pos + 2
            props = bytearray()
            children = []
            while True:
                b = d[p]
                if b == 0xFD:
                    props.append(d[p + 1]); p += 2
                elif b == 0xFE:
                    break
                elif b == 0xFF:
                    return nodes + [(ntype, bytes(props), None)], p + 1
                else:
                    props.append(b); p += 1
            # children
            kids, endp = read_nodes(p, depth + 1)
            nodes.append((ntype, bytes(props), kids, endp))
            pos = endp
        return nodes, pos

    # simpler recursive walk
    def walk(pos):
        # at pos: expect 0xFE
        assert d[pos] == 0xFE, f"no node at {pos}"
        ntype = d[pos + 1]
        p = pos + 2
        props = bytearray()
        kids = []
        while True:
            b = d[p]
            if b == 0xFD:
                props.append(d[p + 1]); p += 2
            elif b == 0xFE:
                k, p = walk(p)
                kids.append(k)
            elif b == 0xFF:
                p += 1
                return (ntype, bytes(props), kids), p
            else:
                props.append(b); p += 1

    assert d[pos] == 0xFE
    root, _ = walk(pos)

    GROUP_SPLASH, GROUP_FLUID, GROUP_CHARGES = 11, 12, 5
    for ntype, props, kids in root[2]:
        if len(props) < 4:
            continue
        flags = struct.unpack_from("<I", props, 0)[0]
        serverId = clientId = None
        p = 4
        while p + 3 <= len(props):
            attr = props[p]; dlen = struct.unpack_from("<H", props, p + 1)[0]
            data = props[p + 3:p + 3 + dlen]
            if attr == 0x10 and dlen == 2: serverId = struct.unpack("<H", data)[0]
            if attr == 0x11 and dlen == 2: clientId = struct.unpack("<H", data)[0]
            p += 3 + dlen
        if clientId is None:
            continue
        items[clientId] = {
            "serverId": serverId,
            "stackable": bool(flags & (1 << 7)),
            "splash": ntype == GROUP_SPLASH,
            "fluid": ntype == GROUP_FLUID,
            "charges": ntype == GROUP_CHARGES,
            "anim": bool(flags & (1 << 24)),
        }
    return items

# ---------------- DAT (client flags per item id) ----------------
def parse_dat(path):
    d = open(path, "rb").read()
    sig = struct.unpack_from("<I", d, 0)[0]
    counts = struct.unpack_from("<HHHH", d, 4)
    print(f"dat sig={sig:#x} items={counts[0]} creatures={counts[1]} effects={counts[2]} missiles={counts[3]}")
    pos = 12
    items = {}

    # attrs with data for version>=1000 mapping (file attr -> mapped):
    # file 16->NoMoveAnim(0B), file>16 -> file-1 mapped id
    # data sizes by MAPPED attr id:
    DAT_U16 = {0, 8, 9, 25, 26, 28, 29, 30, 32, 251}  # ground, writable, writableonce, displacement? careful
    # handled explicitly below per mapped attr
    def mapped(a):
        if a == 16: return 253      # NoMoveAnimation
        if a == 254: return 34      # Usable
        if a == 35: return 251      # DefaultAction
        if a > 16: return a - 1
        return a

    n_items = counts[0]
    for iid in range(100, 100 + n_items):
        istart = pos
        if pos + 10 >= len(d):
            print(f"ran out at item {iid} pos {pos}")
            break
        stackable = fluid = splash = chargeable = False
        while True:
            a = d[pos]; pos += 1
            if a == 0xFF:
                break
            m = mapped(a)
            if m == 5: stackable = True
            elif m == 10: fluid = True
            elif m == 11: splash = True
            elif m == 254: chargeable = True
            # data payloads by mapped attr (version>=1000)
            if m == 0: pos += 2                    # ground speed
            elif m == 8 or m == 9: pos += 2        # writable/once maxlen
            elif m == 21: pos += 4                 # light
            elif m == 24: pos += 4                 # displacement
            elif m == 25: pos += 2                 # elevation
            elif m == 28: pos += 2                 # minimap
            elif m == 29: pos += 2                 # lenshelp
            elif m == 32: pos += 2                 # cloth
            elif m == 33:                          # market
                pos += 6
                slen = struct.unpack_from("<H", d, pos)[0]; pos += 2 + slen + 4
            elif m == 251: pos += 2                # default action
            # usable(34): no data in read path
            # others: no data
        # frame groups (groupCount=1 for items; GameIdleAnimations only creatures)
        w = d[pos]; h = d[pos + 1]; pos += 2
        if w > 1 or h > 1:
            pos += 1  # realSize
        layers = d[pos]; px = d[pos + 1]; py = d[pos + 2]; pz = d[pos + 3]; pos += 4
        phases = d[pos]; pos += 1
        if phases > 1:  # GameEnhancedAnimations -> animator
            pos += 1 + 4 + 1 + phases * 8   # async + loopCount + startPhase + durations
        n_sprites = w * h * layers * px * py * pz * phases
        pos += n_sprites * 4  # GameSpritesU32
        if n_sprites > 8192 or pos > len(d):
            print(f"SUSPECT item {iid}: w={w} h={h} lay={layers} px={px} py={py} pz={pz} ph={phases} istart={istart} ctx={d[istart-8:istart+24].hex()}")
            break
        if pos > len(d):
            print(f"item {iid}: overshot end pos={pos} len={len(d)} w={w} h={h} lay={layers} px={px} py={py} pz={pz} ph={phases} istart={istart}")
            break
        items[iid] = {
            "stackable": stackable, "fluid": fluid, "splash": splash,
            "chargeable": chargeable, "phases": phases,
        }
    print(f"parsed {len(items)} dat items, end pos {pos}/{len(d)}")
    return items

# ---------------- packet replay ----------------
d = open(PACKET, "rb").read()
HDR = 47  # opcode 0x64
pos = HDR + 1
x, y, z = struct.unpack_from("<HHB", d, pos); pos += 5
print(f"mapdesc pos=({x},{y},{z})")

WIDTH, HEIGHT = 34, 20

def peek16(p): return struct.unpack_from("<H", d, p)[0]
def getstr(p):
    l = struct.unpack_from("<H", d, p)[0]
    return p + 2 + l

def parse_item(p, fl, mode):
    """mode='server' uses otb flags, 'client' uses dat flags. returns (end, size)"""
    cid = peek16(p)
    f = fl.get(cid)
    if f is None:
        return None, cid, f"no flags for id {cid}"
    p += 3  # id + 0xFF mark
    if mode == "server":
        count = f["stackable"] or f["splash"] or f["fluid"]
        anim = f["anim"]
    else:
        count = f["stackable"] or f["fluid"] or f["splash"] or f["chargeable"]
        anim = f["phases"] > 1
    if count: p += 1
    if anim: p += 1
    p += 1  # tier
    p = getstr(p)  # shader
    p = getstr(p)  # desc
    return p, cid, None

def parse_creature(p):
    t = peek16(p); p += 2
    if t == 0x61:  # UnknownCreature
        p += 8      # removeId + newId
        p += 1      # creatureType
        p = getstr(p)  # name
    else:
        p += 4      # known id
    p += 2          # health, direction
    lt = peek16(p); p += 2
    if lt != 0: p += 5
    else: p += 2    # lookTypeEx
    p += 2          # mount
    p += 6          # wings aura effect (u16 x3)
    p = getstr(p)   # outfit shader
    p += 4          # light u16+u16? -> intensity+color, speed u16 = 2+2
    p += 2          # skull, shield
    if t == 0x61: p += 1  # emblem
    p += 1          # creatureType
    p += 1          # speechBubble / icon
    p += 1          # mark
    p += 2          # helpers
    p += 1          # walkthrough
    p = getstr(p)   # shader
    n = d[p]; p += 1 + 2 * n  # attached effects
    return p

def replay(flags, mode):
    p = pos
    floors = range(7, -1, -1) if z <= 7 else range(z - 2, min(z + 2, 15) + 1)
    tiles = 0
    history = []
    try:
        for fz in floors:
            for nx in range(WIDTH):
                if p + 2 > len(d):
                    return p, tiles, "eof at tile start"
                skip = peek16(p)
                if skip >= 0xFF00:
                    p += 2
                    continue
                p += 2  # env effect u16
                while True:
                    if p + 2 > len(d):
                        return p, tiles, "eof in things"
                    v = peek16(p)
                    if v >= 0xFF00:
                        p += 2
                        break
                    if v in (0x61, 0x62):
                        np = parse_creature(p)
                        history.append((p, np, f"creature {v:#x}"))
                        p = np
                    else:
                        np, cid, err = parse_item(p, flags, mode)
                        if err:
                            return p, tiles, f"{err} at offset {p}"
                        history.append((p, np, f"item {cid}"))
                        p = np
                    if p > len(d):
                        return p, tiles, f"overshot after {history[-1][2]} at {history[-1][0]}"
                tiles += 1
    except Exception as e:
        print(f"  exc at {p}: {e}")
    finally:
        for h in history[-8:]:
            print(f"    thing @{h[0]}..{h[1]}: {h[2]}")
    return p, tiles, f"stopped {p} != {len(d)} (diff {len(d)-p})"

otb = parse_otb(OTB_SERVER)
print(f"server-otb items: {len(otb)}")
dat = parse_dat(DAT)

# flag mismatch summary (server otb vs client dat)
mism = []
for cid, of in otb.items():
    df = dat.get(cid)
    if not df: continue
    if of["stackable"] != df["stackable"] or (of["splash"] or of["fluid"]) != (df["splash"] or df["fluid"]) or of["anim"] != (df["phases"] > 1):
        mism.append((cid, of, df))
print(f"flag mismatches server-otb-vs-client-dat: {len(mism)}")
for c, o, f in mism[:20]:
    print(f"  id {c}: srv stack={o['stackable']} spl/fl={o['splash'] or o['fluid']} anim={o['anim']} | dat stack={f['stackable']} spl/fl={f['splash'] or f['fluid']} phases={f['phases']}")

p, t, r = replay(otb, "server")
print(f"[server-mode] ended at {p}, tiles {t}: {r}")
p2, t2, r2 = replay(dat, "client")
print(f"[client-mode] ended at {p2}, tiles {t2}: {r2}")
