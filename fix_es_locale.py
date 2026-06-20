#!/usr/bin/env python3
# Fix Spanish locale: encoding, accents, English fragments
import re

INPUT = r"c:\Users\nokturno\Downloads\es_reworked.lua"
OUTPUT = r"c:\Users\nokturno\Desktop\mehah-withupstream2\otclient\data\locales\es.lua"

with open(INPUT, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix charset
content = content.replace('charset = "cp1252"', 'charset = "utf-8"')

# Fix languageName - the corruption: EspaÃ±ol -> Español
content = content.replace('EspaÃ±ol', 'Español')

# The "Ã¡" pattern: UTF-8 bytes for á (0xC3 0xA1) read as CP1252 = Ã¡
# We need to encode as CP1252 then decode as UTF-8
# But since we already read as UTF-8, the bytes are already interpreted
# The pattern "Ã¡" in the file is literally the characters Ã (U+00C3) and ¡ (U+00A1)
# We need to convert these back

# Build a mapping of corrupted UTF-8 sequences
# When CP1252 text with accents is read as UTF-8:
corrupt_map = {}
for char, utf8_bytes in [
    ('á', b'\xc3\xa1'), ('é', b'\xc3\xa9'), ('í', b'\xc3\xad'),
    ('ó', b'\xc3\xb3'), ('ú', b'\xc3\xba'), ('ñ', b'\xc3\xb1'),
    ('Á', b'\xc3\x81'), ('É', b'\xc3\x89'), ('Í', b'\xc3\x8d'),
    ('Ó', b'\xc3\x93'), ('Ú', b'\xc3\x9a'), ('Ñ', b'\xc3\x91'),
    ('ü', b'\xc3\xbc'), ('Ü', b'\xc3\x9c'),
    ('¿', b'\xc2\xbf'), ('¡', b'\xc2\xa1'),
]:
    # What it looks like when CP1252 bytes are interpreted as UTF-8 chars
    corrupted = utf8_bytes.decode('cp1252')
    corrupt_map[corrupted] = char

for corrupted, fixed in corrupt_map.items():
    content = content.replace(corrupted, fixed)

# Now fix missing accents in common words (words that were typed without accents)
accent_fixes = [
    # ñ missing tilde
    ('danio', 'daño'), ('danios', 'daños'), ('danado', 'dañado'),
    # Missing á
    ('maximo', 'máximo'), ('maxima', 'máxima'), ('minimo', 'mínimo'),
    ('magico', 'mágico'), ('magica', 'mágica'), ('arbol', 'árbol'),
    ('ultimo', 'último'), ('sismico', 'sísmico'), ('sismica', 'sísmica'),
    # Missing é
    ('etera', 'étera'), ('etereo', 'etéreo'), ('eterea', 'etérea'),
    # Missing í
    ('critico', 'crítico'), ('critica', 'crítica'), ('fisico', 'físico'),
    ('fisica', 'física'), ('dragon', 'dragón'), ('demonio', 'demonio'),
    ('draconico', 'dracónico'), ('draconica', 'dracónica'),
    # Missing ó
    ('armonia', 'armonía'), ('armonico', 'armónico'), ('armonica', 'armónica'),
    ('demonaco', 'demoníaco'), ('demonaca', 'demoníaca'),
    # Missing ú
    ('unico', 'único'), ('unica', 'única'),
    # Common verb forms
    ('caidos', 'caídos'), ('caido', 'caído'), ('caidas', 'caídas'),
    ('reido', 'reído'), ('oido', 'oído'),
    # Missing accent on i in -ción words (already handled by corrupt_map mostly)
    ('curacion', 'curación'), ('curaciones', 'curaciones'),
    ('regeneracion', 'regeneración'), ('sincronizacion', 'sincronización'),
    ('persecucion', 'persecución'), ('violacion', 'violación'),
    ('informacion', 'información'), ('notacion', 'notación'),
    ('descripcion', 'descripción'), ('posicion', 'posición'),
    ('vocacion', 'vocación'), ('invocacion', 'invocación'),
    ('invocaciones', 'invocaciones'), ('destruccion', 'destrucción'),
    ('explosion', 'explosión'), ('expansion', 'expansión'),
    ('decision', 'decisión'), ('precision', 'precisión'),
    ('confusion', 'confusión'), ('dimension', 'dimensión'),
    ('condicion', 'condición'), ('conexion', 'conexión'),
    ('desconexion', 'desconexión'), ('seleccion', 'selección'),
    ('coleccion', 'colección'), ('proteccion', 'protección'),
    ('accion', 'acción'), ('reaccion', 'reacción'),
    ('interaccion', 'interacción'), ('maldicion', 'maldición'),
    ('bendicion', 'bendición'), ('cancion', 'canción'),
    ('mencion', 'mención'), ('municion', 'munición'),
    ('nutricion', 'nutrición'), ('particion', 'partición'),
    ('peticion', 'petición'), ('competicion', 'competición'),
    ('repeticion', 'repetición'), ('edicion', 'edición'),
    ('expedicion', 'expedición'), ('fundicion', 'fundición'),
    ('rendicion', 'rendición'), ('tradicion', 'tradición'),
    ('adiccion', 'adicción'), ('contradiccion', 'contradicción'),
    ('prediccion', 'predicción'), ('ficcion', 'ficción'),
    ('friccion', 'fricción'), ('restriccion', 'restricción'),
    ('conviccion', 'convicción'), ('conduccion', 'conducción'),
    ('deduccion', 'deducción'), ('induccion', 'inducción'),
    ('introduccion', 'introducción'), ('produccion', 'producción'),
    ('reproduccion', 'reproducción'), ('reduccion', 'reducción'),
    ('seduccion', 'seducción'), ('traduccion', 'traducción'),
    ('construccion', 'construcción'), ('reconstruccion', 'reconstrucción'),
    ('instruccion', 'instrucción'), ('obstruccion', 'obstrucción'),
    ('suscripcion', 'suscripción'), ('inscripcion', 'inscripción'),
    ('prescripcion', 'prescripción'), ('transcripcion', 'transcripción'),
    ('absorcion', 'absorción'), ('distorsion', 'distorsión'),
    ('extorsion', 'extorsión'), ('nocion', 'noción'),
    ('emocion', 'emoción'), ('promocion', 'promoción'),
    ('conmocion', 'conmoción'), ('devocion', 'devoción'),
    ('pocion', 'poción'), ('proporcion', 'proporción'),
    ('porcion', 'porción'), ('aprobacion', 'aprobación'),
    ('comprobacion', 'comprobación'), ('publicacion', 'publicación'),
    ('comunicacion', 'comunicación'), ('explicacion', 'explicación'),
    ('implicacion', 'implicación'), ('complicacion', 'complicación'),
    ('aplicacion', 'aplicación'), ('duplicacion', 'duplicación'),
    ('multiplicacion', 'multiplicación'), ('fabricacion', 'fabricación'),
    ('educacion', 'educación'), ('recomendacion', 'recomendación'),
    ('consolidacion', 'consolidación'), ('validacion', 'validación'),
    ('creacion', 'creación'), ('recreacion', 'recreación'),
    ('asimilacion', 'asimilación'), ('compilacion', 'compilación'),
    ('recopilacion', 'recopilación'), ('ventilacion', 'ventilación'),
    ('destilacion', 'destilación'), ('mutilacion', 'mutilación'),
    ('aniquilacion', 'aniquilación'), ('inmolacion', 'inmolación'),
    ('consolacion', 'consolación'), ('desolacion', 'desolación'),
    ('acumulacion', 'acumulación'), ('acumulaciones', 'acumulaciones'),
    ('estimulacion', 'estimulación'), ('simulacion', 'simulación'),
    ('formulacion', 'formulación'), ('manipulacion', 'manipulación'),
    ('especulacion', 'especulación'), ('articulacion', 'articulación'),
    ('calculacion', 'calculación'), ('circulacion', 'circulación'),
    ('regulacion', 'regulación'), ('anulacion', 'anulación'),
    ('modulacion', 'modulación'), ('emulacion', 'emulación'),
    ('tabulacion', 'tabulación'), ('dramatizacion', 'dramatización'),
    ('sistematizacion', 'sistematización'), ('automatizacion', 'automatización'),
    ('confirmacion', 'confirmación'), ('afirmacion', 'afirmación'),
    ('exclamacion', 'exclamación'), ('proclamacion', 'proclamación'),
    ('reclamacion', 'reclamación'), ('declaracion', 'declaración'),
    ('preparacion', 'preparación'), ('separacion', 'separación'),
    ('reparacion', 'reparación'), ('comparacion', 'comparación'),
    ('migracion', 'migración'), ('emigracion', 'emigración'),
    ('inmigracion', 'inmigración'), ('integracion', 'integración'),
    ('administracion', 'administración'), ('demostracion', 'demostración'),
    ('ilustracion', 'ilustración'), ('restauracion', 'restauración'),
    ('configuracion', 'configuración'), ('inauguracion', 'inauguración'),
    ('depuracion', 'depuración'), ('maduracion', 'maduración'),
    ('saturacion', 'saturación'), ('rotacion', 'rotación'),
    ('anotacion', 'anotación'), ('precipitacion', 'precipitación'),
    ('excitacion', 'excitación'), ('incitacion', 'incitación'),
    ('conciliacion', 'conciliación'), ('reconciliacion', 'reconciliación'),
    ('mediacion', 'mediación'), ('expiacion', 'expiación'),
    ('apropiacion', 'apropiación'), ('expropiacion', 'expropiación'),
    ('participacion', 'participación'), ('anticipacion', 'anticipación'),
    ('ocupacion', 'ocupación'), ('preocupacion', 'preocupación'),
    ('recuperacion', 'recuperación'), ('refrigeracion', 'refrigeración'),
    ('aceleracion', 'aceleración'), ('toleracion', 'toleración'),
    ('conmemoracion', 'conmemoración'), ('evaporacion', 'evaporación'),
    ('incorporacion', 'incorporación'), ('colaboracion', 'colaboración'),
    ('decoracion', 'decoración'), ('exploracion', 'exploración'),
    ('valoracion', 'valoración'), ('elaboracion', 'elaboración'),
    ('perforacion', 'perforación'), ('evaporacion', 'evaporación'),
    ('corporacion', 'corporación'), ('incorporacion', 'incorporación'),
    ('descorporacion', 'descorporación'),
    ('inspiracion', 'inspiración'), ('aspiracion', 'aspiración'),
    ('respiracion', 'respiración'), ('transpiracion', 'transpiración'),
    ('conspiracion', 'conspiración'), ('respiracion', 'respiración'),
    ('generacion', 'generación'), ('degeneracion', 'degeneración'),
    ('regeneracion', 'regeneración'), ('operacion', 'operación'),
    ('cooperacion', 'cooperación'), ('exageracion', 'exageración'),
    ('laceracion', 'laceración'), ('maceracion', 'maceración'),
    ('incineracion', 'incineración'), ('iteracion', 'iteración'),
    ('reiteracion', 'reiteración'), ('alteracion', 'alteración'),
    ('adulteracion', 'adulteración'), ('conmemoracion', 'conmemoración'),
    ('remuneracion', 'remuneración'), ('evaporacion', 'evaporación'),
    ('corporacion', 'corporación'), ('restauracion', 'restauración'),
    ('suscripcion', 'suscripción'), ('transcripcion', 'transcripción'),
    ('prescripcion', 'prescripción'), ('inscripcion', 'inscripción'),
    ('adscripcion', 'adscripción'), ('circunscripcion', 'circunscripción'),
    ('absorcion', 'absorción'), ('resorcion', 'resorción'),
    ('excursion', 'excursión'), ('incursion', 'incursión'),
    ('percusion', 'percusión'), ('repercusion', 'repercusión'),
    ('discusion', 'discusión'), ('concusion', 'concusión'),
    ('difusion', 'difusión'), ('efusion', 'efusión'),
    ('infusion', 'infusión'), ('profusion', 'profusión'),
    ('transfusion', 'transfusión'), ('conclusion', 'conclusión'),
    ('exclusion', 'exclusión'), ('inclusion', 'inclusión'),
    ('reclusion', 'reclusión'), ('oclusion', 'oclusión'),
    ('alusion', 'alusión'), ('ilusion', 'ilusión'),
    ('desilusion', 'desilusión'), ('colision', 'colisión'),
    ('elision', 'elisión'), ('precision', 'precisión'),
    ('imprecision', 'imprecisión'), ('indecision', 'indecisión'),
    ('division', 'división'), ('subdivision', 'subdivisión'),
    ('revision', 'revisión'), ('prevision', 'previsión'),
    ('supervision', 'supervisión'), ('television', 'televisión'),
    ('provision', 'provisión'), ('emision', 'emisión'),
    ('remision', 'remisión'), ('admision', 'admisión'),
    ('transmision', 'transmisión'), ('comision', 'comisión'),
    ('omision', 'omisión'), ('sumision', 'sumisión'),
    ('permision', 'permisión'), ('posesion', 'posesión'),
    ('obsesion', 'obsesión'), ('cesion', 'cesión'),
    ('concesion', 'concesión'), ('sucesion', 'sucesión'),
    ('procesion', 'procesión'), ('agresion', 'agresión'),
    ('regresion', 'regresión'), ('progresion', 'progresión'),
    ('transgresion', 'transgresión'), ('presion', 'presión'),
    ('compresion', 'compresión'), ('impresion', 'impresión'),
    ('opresion', 'opresión'), ('represion', 'represión'),
    ('supresion', 'supresión'), ('expresion', 'expresión'),
    ('depresion', 'depresión'), ('sesion', 'sesión'),
    ('mision', 'misión'), ('vision', 'visión'),
    ('excavacion', 'excavación'), ('elevacion', 'elevación'),
    ('renovacion', 'renovación'), ('innovacion', 'innovación'),
    ('conservacion', 'conservación'), ('observacion', 'observación'),
    ('reservacion', 'reservación'), ('curvacion', 'curvación'),
    ('salvacion', 'salvación'), ('excavacion', 'excavación'),
    ('depravacion', 'depravación'), ('agravacion', 'agravación'),
    ('elevacion', 'elevación'), ('renovacion', 'renovación'),
    ('aprobacion', 'aprobación'), ('comprobacion', 'comprobación'),
    ('incubacion', 'incubación'), ('perturbacion', 'perturbación'),
    # Special cases
    ('despues', 'después'), ('tambien', 'también'),
    ('asi', 'así'), ('aqui', 'aquí'), ('alli', 'allí'),
    ('ahi', 'ahí'), ('si', 'sí'),  # careful with 'si' (if)
    ('que', 'qué'),  # only in questions
    ('como', 'cómo'),  # only in questions
    ('cuando', 'cuándo'), ('donde', 'dónde'),
    ('cuanto', 'cuánto'), ('cual', 'cuál'),
    ('quien', 'quién'), ('porque', 'porqué'),
    # But these are tricky - let's skip the interrogative ones for now
    # and focus on clear cases
]

# Apply accent fixes - but only in translation values, not keys
# We'll apply them globally since keys are English and won't match Spanish words
for wrong, right in accent_fixes:
    content = content.replace(wrong, right)

# Fix common English fragments left in Spanish translations
english_fixes = [
    # "to grant" -> "de otorgar"
    ('to grant +', 'de otorgar +'),
    ('to grant', 'de otorgar'),
    # "for Xs" -> "por Xs"
    ('for 3s', 'por 3s'), ('for 5s', 'por 5s'), ('for 6s', 'por 6s'),
    ('for 10s', 'por 10s'), ('for 4s', 'por 4s'), ('for 8s', 'por 8s'),
    ('for 2s', 'por 2s'), ('for 1.5s', 'por 1.5s'),
    # "grow" -> "crecer"
    ('grow 10%', 'crecer 10%'), ('grow 15%', 'crecer 15%'),
    ('grow 20%', 'crecer 20%'), ('grow 25%', 'crecer 25%'),
    ('grow 30%', 'crecer 30%'), ('grow 35%', 'crecer 35%'),
    ('grow 40%', 'crecer 40%'), ('grow 45%', 'crecer 45%'),
    ('grow 5%', 'crecer 5%'), ('grow 50%', 'crecer 50%'),
    # "attacks have a" -> "los ataques tienen"
    ('attacks have a', 'los ataques tienen'),
    ('attacks have', 'los ataques tienen'),
    # "kills have a" -> "las muertes tienen"
    ('kills have a', 'las muertes tienen'),
    ('kills have', 'las muertes tienen'),
    # "to heal" -> "de curar"
    ('to heal', 'de curar'),
    # "to unleash" -> "de desatar"
    ('to unleash', 'de desatar'),
    # "to summon" -> "de invocar"
    ('to summon', 'de invocar'),
    # "to gana" -> "de ganar"
    ('to gana', 'de ganar'),
    # "movement velocidad" -> "velocidad de movimiento"
    ('movement velocidad', 'velocidad de movimiento'),
    ('movement speed', 'velocidad de movimiento'),
    # "a shield equal to" -> "un escudo igual a"
    ('a shield equal to', 'un escudo igual a'),
    # "chain lightning" -> "cadena de relámpagos"
    ('chain lightning', 'cadena de relámpagos'),
    # "of danio causat" -> "del daño causado"
    ('of danio causat', 'del daño causado'),
    # "below" -> "por debajo de" (in context of HP thresholds)
    ('below 20% HP', 'por debajo de 20% HP'),
    ('below 23% HP', 'por debajo de 23% HP'),
    ('below 25% HP', 'por debajo de 25% HP'),
    ('below 26% HP', 'por debajo de 26% HP'),
    ('below 28% HP', 'por debajo de 28% HP'),
    ('below 29% HP', 'por debajo de 29% HP'),
    ('below 30% HP', 'por debajo de 30% HP'),
    ('below 32% HP', 'por debajo de 32% HP'),
    ('below 34% HP', 'por debajo de 34% HP'),
    ('below 35% HP', 'por debajo de 35% HP'),
    ('below 36% HP', 'por debajo de 36% HP'),
    ('below 38% HP', 'por debajo de 38% HP'),
    ('below 40% HP', 'por debajo de 40% HP'),
    ('below 41% HP', 'por debajo de 41% HP'),
    ('below 42% HP', 'por debajo de 42% HP'),
    ('below 44% HP', 'por debajo de 44% HP'),
    ('below 45% HP', 'por debajo de 45% HP'),
    ('below 47% HP', 'por debajo de 47% HP'),
    ('below 50%', 'por debajo de 50%'),
    # "and" -> "y" (in mixed translations)
    ('and +10%', 'y +10%'), ('and +12%', 'y +12%'),
    ('and +14%', 'y +14%'), ('and +16%', 'y +16%'),
    ('and +18%', 'y +18%'), ('and +2%', 'y +2%'),
    ('and +20%', 'y +20%'), ('and +4%', 'y +4%'),
    ('and +6%', 'y +6%'), ('and +8%', 'y +8%'),
    ('and +', 'y +'),
    # "bonus experience" -> "experiencia extra"
    ('bonus experience', 'experiencia extra'),
    # "kills restaura" -> "las muertes restauran"
    ('kills restaura', 'las muertes restauran'),
    ('kills restauran', 'las muertes restauran'),
    # "sword" -> "espada" (in Triforce context)
    ('en sword,', 'en espada,'),
    # "shielding" -> "escudo" (skill)
    ('tu shielding', 'tu escudo'),
    # "deck" -> "mazo"
    ('tu deck', 'tu mazo'),
]

for eng, esp in english_fixes:
    content = content.replace(eng, esp)

# Fix "por cada" consistency
content = content.replace('por cada', 'por cada')  # already fine

# Fix "enfriamiento" consistency (already used, keep it)

# Write output as UTF-8
with open(OUTPUT, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Fixed locale written to: {OUTPUT}")
print("Done! Check the file for any remaining issues.")
