class_name GestorIA

var partido
var terreno
var gestorMovimiento
var gestorCombate
var gestorTurnos

func _init(p, t, gm, gc, gt):
	partido = p
	terreno = t
	gestorMovimiento = gm
	gestorCombate = gc
	gestorTurnos = gt

func jugarTurno(personaje: CharacterBody3D) -> void:
	var destinoGol := _buscarMovimientoParaGol(personaje)

	if destinoGol != Vector2i(-1, -1):
		partido.ejecutarMovimientoConPuntuacion(personaje, destinoGol)
		gestorTurnos.terminarTurno()
		return

	var origen: Vector2 = personaje.posicionCuadricula
	var destino: Vector2 = _buscarMejorMovimiento(personaje)

	var colision: Dictionary = gestorMovimiento.detectarColision(origen, destino, personaje)

	if colision.get("bloqueado", false):
		return

	if colision.enemigo == null:
		partido.ejecutarMovimientoConPuntuacion(personaje, destino)
		gestorTurnos.terminarTurno()
		return

	var fuerza: int = personaje.stats.fuerzaEmpuje - colision.casillasHasta
	var resistencia: int = colision.enemigo.stats.resistenciaEmpuje

	if fuerza <= resistencia:
		return

	gestorCombate.iniciarSeleccionEmpuje(personaje, colision.enemigo, destino, false)

	var empuje: Vector2i = elegirEmpuje()

	if empuje != Vector2i.ZERO:
		gestorCombate.resolverEmpuje(empuje)
	
func _buscarMejorMovimiento(personaje: CharacterBody3D) -> Vector2i:
	var origen : Vector2 = personaje.posicionCuadricula
	var alcance : int = personaje.stats.fuerzaEmpuje

	var mejorCasilla : Vector2 = origen
	var mejorValor := -99999

	for x in range(Constantes.ANCHO_MAPA):
		for y in range(Constantes.LARGO_MAPA):

			var destino := Vector2i(x, y)

			if not gestorMovimiento.comprobarMovimientoValido(origen, destino, alcance):
				continue

			var ocupante : CharacterBody3D = terreno.getOcupante(destino)
			if ocupante != null and ocupante.stats.equipo.to_lower() == personaje.stats.equipo.to_lower():
				continue

			var colision : Dictionary= gestorMovimiento.detectarColision(origen, destino, personaje)

			if colision.get("bloqueado", false):
				continue

			var valor := _evaluarMovimiento(personaje, destino, colision)

			if valor > mejorValor:
				mejorValor = valor
				mejorCasilla = destino

	return mejorCasilla
	
func _evaluarMovimiento(personaje: CharacterBody3D, destino: Vector2i, colision: Dictionary) -> int:
	var valor := 0

	if personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO:
		valor += 100 - destino.y * 10

	else:
		valor += destino.y * 10

	if colision.enemigo != null:
		var fuerza : int = personaje.stats.fuerzaEmpuje - colision.casillasHasta
		var resistencia : int = colision.enemigo.stats.resistenciaEmpuje

		if fuerza > resistencia:
			valor += 200
		else:
			valor -= 100

	return valor
	
func elegirEmpuje() -> Vector2i:
	if gestorCombate.casillasValidas.is_empty():
		return Vector2i.ZERO

	var mejor : Vector2 = gestorCombate.casillasValidas[0]
	var mejorValor := -99999

	for pos in gestorCombate.casillasValidas:

		var valor := 0

		valor -= pos.y

		if valor > mejorValor:
			mejorValor = valor
			mejor = pos

	return mejor

func _buscarMovimientoParaGol(personaje: CharacterBody3D) -> Vector2i:
	var origen: Vector2i = personaje.posicionCuadricula
	var alcance: int = personaje.stats.fuerzaEmpuje

	for x in range(Constantes.ANCHO_MAPA):
		for y in range(Constantes.LARGO_MAPA):
			var destino := Vector2i(x, y)

			if not gestorMovimiento.comprobarMovimientoValido(origen, destino, alcance):
				continue

			var ocupante: CharacterBody3D = terreno.getOcupante(destino)
			if ocupante != null:
				continue

			if _esMovimientoDeGol(personaje, destino):
				return destino

	return Vector2i(-1, -1)


func _esMovimientoDeGol(personaje: CharacterBody3D, destino: Vector2i) -> bool:
	var equipo: String = personaje.stats.equipo.to_lower()

	if equipo == Constantes.EQUIPO_ROJO:
		return destino.y == Constantes.LINEA_GOL_ROJO
	else:
		return destino.y == Constantes.LINEA_GOL_AZUL
