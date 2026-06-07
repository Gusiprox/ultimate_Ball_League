class_name GestorMovimiento

var distanciaHorizontal: int
var distanciaVertical: int
var distanciaTotal: int

var enemigosEncontrados: Array[Dictionary]

var movimiento: Vector2i
var posicionActual: Vector2i

var ocupante: CharacterBody3D

var terreno: Node3D

func _init(t: Node3D) -> void:
	terreno = t

func ejecutarMovimiento(p: CharacterBody3D, pos: Vector2i) -> void:
	if comprobarCasillaOcupadaPorAliado(pos, p):
		return

	if terreno.comprobarCasillaOcupada(pos):
		return

	terreno.liberarCasilla(p.posicionCuadricula)
	p.moverPersonaje(pos)
	terreno.ocuparCasilla(pos, p)

func comprobarMovimientoValido(origen: Vector2i, destino: Vector2i, fuerzaEmpuje: int) -> bool:
	distanciaHorizontal = abs(destino.x - origen.x)
	distanciaVertical = abs(destino.y - origen.y)

	if distanciaHorizontal != 0 and distanciaVertical != 0:
		return false

	return distanciaHorizontal + distanciaVertical > 0 and distanciaHorizontal + distanciaVertical <= fuerzaEmpuje

func detectarColision(origen: Vector2i, destino: Vector2i, personajeActual: CharacterBody3D) -> Dictionary:
	movimiento = _obtenerPaso(origen, destino)

	if movimiento == Vector2i.ZERO:
		return {Constantes.DICTIONARY_KEY_BLOQUEADO: false, Constantes.DICTIONARY_KEY_ENEMIGO: null}

	distanciaTotal = abs(destino.x - origen.x) + abs(destino.y - origen.y)

	posicionActual = origen
	enemigosEncontrados = []

	for i in range(1, distanciaTotal + 1):
		posicionActual += movimiento

		if terreno.comprobarCasillaOcupada(posicionActual):
			ocupante = terreno.getOcupante(posicionActual)

			if ocupante != null and not _mismoEquipo(ocupante, personajeActual):
				enemigosEncontrados.append({Constantes.DICTIONARY_KEY_ENEMIGO: ocupante, Constantes.DICTIONARY_KEY_POSICION: posicionActual, Constantes.DICTIONARY_KEY_DISTANCIA: i - 1})

		if posicionActual == destino:
			break

	if enemigosEncontrados.size() >= 2:
		return {Constantes.DICTIONARY_KEY_BLOQUEADO: true, Constantes.DICTIONARY_KEY_ENEMIGO: null}

	if enemigosEncontrados.size() == 1:
		return {Constantes.DICTIONARY_KEY_BLOQUEADO: false, Constantes.DICTIONARY_KEY_ENEMIGO: enemigosEncontrados[0][Constantes.DICTIONARY_KEY_ENEMIGO], Constantes.DICTIONARY_KEY_CASILLAS: enemigosEncontrados[0][Constantes.DICTIONARY_KEY_DISTANCIA], Constantes.DICTIONARY_KEY_POSICION_ENEMIGO: enemigosEncontrados[0][Constantes.DICTIONARY_KEY_POSICION]}

	return {Constantes.DICTIONARY_KEY_BLOQUEADO: false, Constantes.DICTIONARY_KEY_ENEMIGO: null}

func _obtenerPaso(origen: Vector2i, destino: Vector2i) -> Vector2i:
	if destino.x > origen.x:
		return Vector2i.RIGHT
	if destino.x < origen.x:
		return Vector2i.LEFT
	if destino.y > origen.y:
		return Vector2i.DOWN
	if destino.y < origen.y:
		return Vector2i.UP
	return Vector2i.ZERO

func _mismoEquipo(a: CharacterBody3D, b: CharacterBody3D) -> bool:
	return a.stats.equipo.to_lower() == b.stats.equipo.to_lower()

func comprobarCasillaOcupadaPorAliado(pos: Vector2i, personaje: CharacterBody3D) -> bool:
	if not terreno.comprobarCasillaOcupada(pos):
		return false

	ocupante = terreno.getOcupante(pos)
	if ocupante == null:
		return false

	return ocupante.stats.equipo.to_lower() == personaje.stats.equipo.to_lower()
