class_name GestorMovimiento

var terreno: Node3D

func _init(t: Node3D) -> void:
	terreno = t

func ejecutarMovimiento(p: CharacterBody3D, pos: Vector2i) -> void:
	if esCasillaOcupadaPorAliado(pos, p):
		return

	if terreno.comprobarCasillaOcupada(pos):
		return

	terreno.liberarCasilla(p.posicionCuadricula)
	p.moverA(pos)
	terreno.ocuparCasilla(pos, p)

func comprobarMovimientoValido(origen: Vector2i, destino: Vector2i, fuerzaEmpuje: int) -> bool:
	var distanciaHorizontal: int = abs(destino.x - origen.x)
	var distanciaVertical: int = abs(destino.y - origen.y)

	if distanciaHorizontal != 0 and distanciaVertical != 0:
		return false

	return distanciaHorizontal + distanciaVertical > 0 and distanciaHorizontal + distanciaVertical <= fuerzaEmpuje

func detectarColision(origen: Vector2i, destino: Vector2i, personajeActual: CharacterBody3D) -> Dictionary:
	var movimiento: Vector2i = _obtenerPaso(origen, destino)

	if movimiento == Vector2i.ZERO:
		return {"bloqueado": false, "enemigo": null}

	var distanciaTotal: int = abs(destino.x - origen.x) + abs(destino.y - origen.y)

	var posicionActual: Vector2i = origen
	var enemigosEncontrados: Array[Dictionary] = []

	for i in range(1, distanciaTotal + 1):
		posicionActual += movimiento

		if terreno.comprobarCasillaOcupada(posicionActual):
			var ocupante: CharacterBody3D = terreno.getOcupante(posicionActual)

			if ocupante != null and not _mismoEquipo(ocupante, personajeActual):
				enemigosEncontrados.append({"enemigo": ocupante, "posicion": posicionActual, "distancia": i - 1})

		if posicionActual == destino:
			break

	if enemigosEncontrados.size() >= 2:
		return {"bloqueado": true, "enemigo": null}

	if enemigosEncontrados.size() == 1:
		return {"bloqueado": false, "enemigo": enemigosEncontrados[0].enemigo, "casillasHasta": enemigosEncontrados[0].distancia, "posicionEnemigo": enemigosEncontrados[0].posicion}

	return {"bloqueado": false, "enemigo": null}

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

func esCasillaOcupadaPorAliado(pos: Vector2i, personaje: CharacterBody3D) -> bool:
	if not terreno.comprobarCasillaOcupada(pos):
		return false

	var ocupante: CharacterBody3D = terreno.getOcupante(pos)
	if ocupante == null:
		return false

	return ocupante.stats.equipo.to_lower() == personaje.stats.equipo.to_lower()
