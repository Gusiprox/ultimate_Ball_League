class_name GestorIA

var partido
var terreno
var gestorMovimiento
var gestorCombate
var gestorTurnos

var equipo: String

var fuerza: int
var resistencia: int
var alcance: int
var valor : int
var mejorOpcion: int

var destinoGol: Vector2i
var empuje: Vector2i

var origen: Vector2
var destino: Vector2
var mejorCasilla : Vector2
var prioridadEmpuje : Vector2

var colision: Dictionary

var ocupante : CharacterBody3D

func _init(p, t, gm, gc, gt):
	partido = p
	terreno = t
	gestorMovimiento = gm
	gestorCombate = gc
	gestorTurnos = gt

func jugarTurno(personaje: CharacterBody3D) -> void:
	destinoGol= _buscarMovimientoParaGol(personaje)

	if destinoGol != Vector2i(-1, -1):
		partido.ejecutarMovimientoConPuntuacion(personaje, destinoGol)
		gestorTurnos.terminarTurno()
		return

	origen = personaje.posicionCuadricula
	destino = _buscarMejorMovimiento(personaje)

	colision = gestorMovimiento.detectarColision(origen, destino, personaje)

	if colision.get(Constantes.DICTIONARY_KEY_BLOQUEADO, false):
		return

	if colision[Constantes.DICTIONARY_KEY_ENEMIGO] == null:
		partido.ejecutarMovimientoConPuntuacion(personaje, destino)
		gestorTurnos.terminarTurno()
		return

	fuerza = personaje.stats.fuerzaEmpuje - colision[Constantes.DICTIONARY_KEY_CASILLAS]
	resistencia = colision[Constantes.DICTIONARY_KEY_ENEMIGO].stats.resistenciaEmpuje

	if fuerza <= resistencia:
		return

	gestorCombate.iniciarSeleccionEmpuje(personaje, colision[Constantes.DICTIONARY_KEY_ENEMIGO], destino, false)

	empuje = elegirEmpuje()

	if empuje != Vector2i.ZERO:
		gestorCombate.resolverEmpuje(empuje)
	
func _buscarMejorMovimiento(personaje: CharacterBody3D) -> Vector2i:
	origen = personaje.posicionCuadricula
	alcance = personaje.stats.fuerzaEmpuje

	mejorCasilla = origen
	mejorOpcion = -99999

	for x in range(Constantes.ANCHO_MAPA):
		for y in range(Constantes.LARGO_MAPA):

			destino = Vector2(x, y)

			if not gestorMovimiento.comprobarMovimientoValido(origen, destino, alcance):
				continue

			ocupante = terreno.getOcupante(destino)
			if ocupante != null and ocupante.stats.equipo.to_lower() == personaje.stats.equipo.to_lower():
				continue

			colision = gestorMovimiento.detectarColision(origen, destino, personaje)

			if colision.get(Constantes.DICTIONARY_KEY_BLOQUEADO, false):
				continue

			valor = _evaluarMovimiento(personaje, destino, colision)

			if valor > mejorOpcion:
				mejorOpcion = valor
				mejorCasilla = destino

	return mejorCasilla
	
func _evaluarMovimiento(personaje: CharacterBody3D, d: Vector2i, c: Dictionary) -> int:
	valor = 0

	if personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO:
		valor += 100 - d.y * 10

	else:
		valor += d.y * 10

	if c[Constantes.DICTIONARY_KEY_ENEMIGO] != null:
		fuerza = personaje.stats.fuerzaEmpuje - colision[Constantes.DICTIONARY_KEY_CASILLAS]
		resistencia = colision[Constantes.DICTIONARY_KEY_ENEMIGO].stats.resistenciaEmpuje

		if fuerza > resistencia:
			valor += 200
		else:
			valor -= 100

	return valor
	
func elegirEmpuje() -> Vector2i:
	if gestorCombate.casillasValidas.is_empty():
		return Vector2i.ZERO

	prioridadEmpuje = gestorCombate.casillasValidas[0]
	mejorOpcion = -99999

	for pos in gestorCombate.casillasValidas:

		valor = 0

		valor -= pos.y

		if valor > mejorOpcion:
			mejorOpcion = valor
			prioridadEmpuje = pos

	return prioridadEmpuje

func _buscarMovimientoParaGol(personaje: CharacterBody3D) -> Vector2i:
	origen = personaje.posicionCuadricula
	alcance = personaje.stats.fuerzaEmpuje

	for x in range(Constantes.ANCHO_MAPA):
		for y in range(Constantes.LARGO_MAPA):
			destino = Vector2i(x, y)

			if not gestorMovimiento.comprobarMovimientoValido(origen, destino, alcance):
				continue

			ocupante = terreno.getOcupante(destino)
			if ocupante != null:
				continue

			if _comprobarMovimientoGol(personaje, destino):
				return destino

	return Vector2i(-1, -1)


func _comprobarMovimientoGol(personaje: CharacterBody3D, d: Vector2i) -> bool:
	equipo = personaje.stats.equipo.to_lower()

	if equipo == Constantes.EQUIPO_ROJO:
		return d.y == Constantes.LINEA_GOL_ROJO
	else:
		return d.y == Constantes.LINEA_GOL_AZUL
