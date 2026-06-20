import re
with open(r"c:\Users\nokturno\Downloads\es_reworked.lua", "r", encoding="utf-8") as f:
    c = f.read()

# Fix charset
c = c.replace('charset = "cp1252"', 'charset = "utf-8"')

# Fix languageName
c = c.replace('EspaÃ±ol', 'Español')

# Fix corrupted UTF-8 sequences (CP1252 bytes interpreted as UTF-8)
# Map of corrupted -> correct
cm = {
    'Ã¡': 'á', 'Ã©': 'é', 'Ã­': 'í', 'Ã³': 'ó', 'Ãº': 'ú',
    'Ã±': 'ñ', 'Ã': 'Á', 'Ã‰': 'É', 'Ã': 'Í', 'Ã“': 'Ó', 'Ãš': 'Ú',
    'Ã‘': 'Ñ', 'Ã¼': 'ü', 'Ãœ': 'Ü', 'Â¿': '¿', 'Â¡': '¡',
}
for k, v in cm.items():
    c = c.replace(k, v)

# Fix common missing accents using regex word boundaries
accent_map = {
    'danio': 'daño', 'maximo': 'máximo', 'maxima': 'máxima',
    'minimo': 'mínimo', 'magico': 'mágico', 'magica': 'mágica',
    'critico': 'crítico', 'critica': 'crítica', 'fisico': 'físico',
    'fisica': 'física', 'armonia': 'armonía', 'unico': 'único',
    'unica': 'única', 'sismico': 'sísmico', 'sismica': 'sísmica',
    'caidos': 'caídos', 'caido': 'caído', 'draconico': 'dracónico',
    'draconica': 'dracónica', 'demonaco': 'demoníaco', 'demonaca': 'demoníaca',
    'etereo': 'etéreo', 'eterea': 'etérea',
}
for k, v in accent_map.items():
    c = re.sub(r'\b' + k + r'\b', v, c)

# Fix -cion words (missing accent)
c = re.sub(r'\b(\w+)(cion)\b', r'\1ción', c)
c = re.sub(r'\b(\w+)(sion)\b', r'\1sión', c)
c = re.sub(r'\b(\w+)(gion)\b', r'\1gión', c)

# Fix common English fragments
eng_fixes = [
    ('to grant', 'de otorgar'),
    ('for 3s', 'por 3s'), ('for 5s', 'por 5s'), ('for 6s', 'por 6s'),
    ('for 10s', 'por 10s'), ('for 4s', 'por 4s'), ('for 8s', 'por 8s'),
    ('for 2s', 'por 2s'), ('for 1.5s', 'por 1.5s'),
    ('movement speed', 'velocidad de movimiento'),
    ('movement velocidad', 'velocidad de movimiento'),
    ('a shield equal to', 'un escudo igual a'),
    ('chain lightning', 'cadena de relámpagos'),
    ('of danio causat', 'del daño causado'),
    ('bonus experience', 'experiencia extra'),
    ('to heal', 'de curar'),
    ('to unleash', 'de desatar'),
    ('to summon', 'de invocar'),
    ('to gana', 'de ganar'),
    ('kills have a', 'las muertes tienen'),
    ('kills have', 'las muertes tienen'),
    ('attacks have a', 'los ataques tienen'),
    ('attacks have', 'los ataques tienen'),
    ('kills restaura', 'las muertes restauran'),
    ('kills restauran', 'las muertes restauran'),
    ('en sword,', 'en espada,'),
    ('tu shielding', 'tu escudo'),
    ('tu deck', 'tu mazo'),
]
for eng, esp in eng_fixes:
    c = c.replace(eng, esp)

# Fix "below X% HP" -> "por debajo de X% HP"
c = re.sub(r'below (\d+\.?\d*)% HP', r'por debajo de \1% HP', c)
c = re.sub(r'below (\d+\.?\d*)%', r'por debajo de \1%', c)

# Fix "grow X%" -> "crecer X%"
c = re.sub(r'grow (\d+)%', r'crecer \1%', c)

# Fix "and +X%" -> "y +X%"
c = re.sub(r'and \+', 'y +', c)

# Fix "for Xs" -> "por Xs" (remaining patterns)
c = re.sub(r'for (\d+\.?\d*)s', r'por \1s', c)

with open(r"c:\Users\nokturno\Desktop\mehah-withupstream2\otclient\data\locales\es.lua", "w", encoding="utf-8") as f:
    f.write(c)
print("Done!")
