class_name GestorHabilidades

var efectosTerminados: Array[int] = []

var efecto: Dictionary

var destino: Vector2i
var direccion: Vector2i

var objetivo: CharacterBody3D
var terreno: Node3D
var cooldowns: Dictionary = {}

func _init(t: Node3D) -> void:
	terreno = t

func activar_habilidad(p: CharacterBody3D, habilidad: String, pos: Vector2i) -> bool:
	if not comprobarUso(p, habilidad):
		return false

	match habilidad:
		Habilidades.ENTRENADOR:
			return _ejecutarHabilidadEntrenador(p, pos)

		Habilidades.FORTALECEDOR:
			return _ejecutarHabilidadFortalecedor(p, pos)

		Habilidades.EMPUJON:
			return _ejecutarHabilidadEmpujon(p, pos)
	return false


func comprobarUso(p: CharacterBody3D, h: String) -> bool:
	return _getTiempoEspera(p, h) <= 0

func procesarCooldownsPersonaje(personaje: CharacterBody3D) -> void:
	if not cooldowns.has(personaje):
		return

	for habilidad in cooldowns[personaje].keys():
		cooldowns[personaje][habilidad] = max(0, cooldowns[personaje][habilidad] - 1)

func procesarFinTurnoPersonaje(personaje: CharacterBody3D) -> void:
	if personaje == null:
		return

	for i in range(personaje.efectosActivos.size() - 1, -1, -1):
		efecto = personaje.efectosActivos[i]
		
		efecto[Constantes.DICTIONARY_KEY_DURACION] -= 1

		if efecto[Constantes.DICTIONARY_KEY_DURACION] <= 0:
			match efecto[Constantes.DICTIONARY_KEY_STAT]:
				Constantes.STATS_FUERZA_EMPUJE:
					personaje.stats.fuerzaEmpuje -= efecto[Constantes.DICTIONARY_KEY_VALOR]

				Constantes.STATS_RESISTENCIA_EMPUJE:
					personaje.stats.resistenciaEmpuje -= efecto[Constantes.DICTIONARY_KEY_VALOR]

			personaje.efectosActivos.remove_at(i)

func _ejecutarHabilidadEntrenador(p: CharacterBody3D, pos: Vector2i) -> bool:
	if not comprobarCasillasAdyacentes(p.posicionCuadricula, pos, 1):
		return false

	objetivo = terreno.getOcupante(pos)
	if objetivo == null:
		return false
		
	if objetivo == p:
		return false

	if objetivo.stats.equipo.to_lower() != p.stats.equipo.to_lower():
		return false

	objetivo.stats.fuerzaEmpuje += 1

	objetivo.efectosActivos.append({
		Constantes.DICTIONARY_KEY_STAT: Constantes.STATS_FUERZA_EMPUJE,
		Constantes.DICTIONARY_KEY_VALOR: 1,
		Constantes.DICTIONARY_KEY_DURACION: 1
	})

	_setTiempoEspera(p, Habilidades.ENTRENADOR, Constantes.COOLDOWN_TRES_TURNOS)
	return true

func _ejecutarHabilidadFortalecedor(p: CharacterBody3D, pos: Vector2i) -> bool:
	if not comprobarCasillasCuadrado(p.posicionCuadricula, pos):
		return false

	objetivo = terreno.getOcupante(pos)
	if objetivo == null:
		return false
		
	if objetivo == p:
		return false

	if objetivo.stats.equipo.to_lower() != p.stats.equipo.to_lower():
		return false

	objetivo.stats.resistenciaEmpuje += 1
	objetivo.efectosActivos.append({
		Constantes.DICTIONARY_KEY_STAT: Constantes.STATS_RESISTENCIA_EMPUJE,
		Constantes.DICTIONARY_KEY_VALOR: 1,
		Constantes.DICTIONARY_KEY_DURACION: 1
	})

	_setTiempoEspera(p, Habilidades.FORTALECEDOR, Constantes.COOLDOWN_TRES_TURNOS)
	return true

func _ejecutarHabilidadEmpujon(p: CharacterBody3D, pos: Vector2i) -> bool:
	if not comprobarCasillasAdyacentes(p.posicionCuadricula, pos, 1):
		return false

	objetivo = terreno.getOcupante(pos)
	if objetivo == null:
		return false

	if objetivo.stats.equipo.to_lower() != p.stats.equipo.to_lower():
		return false

	direccion = pos - p.posicionCuadricula
	direccion = Vector2i(sign(direccion.x), sign(direccion.y))

	destino = pos + direccion

	if not terreno.comprobarDentroDelMapa(destino):
		return false

	if terreno.comprobarCasillaOcupada(destino):
		return false

	terreno.liberarCasilla(pos)
	objetivo.teletransportarACuadricula(destino)
	terreno.ocuparCasilla(destino, objetivo)

	_setTiempoEspera(p, Habilidades.EMPUJON, Constantes.COOLDOWN_DOS_TURNOS)
	return true

func comprobarCasillasAdyacentes(a: Vector2i, b: Vector2i, r: int) -> bool:
	return abs(a.x - b.x) + abs(a.y - b.y) <= r
	
func comprobarCasillasCuadrado(o: Vector2i, d: Vector2i) -> bool:
	return (abs(o.x - d.x) <= 1 and abs(o.y - d.y) <= 1 and o != d)

func _getTiempoEspera(p: CharacterBody3D, h: String) -> int:
	if not cooldowns.has(p):
		return 0
	return cooldowns[p].get(h, 0)

func _setTiempoEspera(p: CharacterBody3D, h: String, t: int) -> void:
	if not cooldowns.has(p):
		cooldowns[p] = {}
	cooldowns[p][h] = t
