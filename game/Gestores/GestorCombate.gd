class_name GestorCombate

signal empujeResuelto(atacante: CharacterBody3D, destino: Vector2i)

var terreno: Node3D
var gestorMovimiento: GestorMovimiento

var enCombate: bool = false
var mostrarUI: bool

var atacante: CharacterBody3D
var defensor: CharacterBody3D
var ocupante: CharacterBody3D

var posicionDefensor: Vector2i
var direccionImpacto: Vector2i
var posicionEmpuje: Vector2i

var destinoAtacante: Vector2i
var casillasValidas: Array[Vector2i] = []

func _init(t: Node3D, gm: GestorMovimiento) -> void:
	terreno = t
	gestorMovimiento = gm

func iniciarSeleccionEmpuje(a: CharacterBody3D, d: CharacterBody3D, destino: Vector2i, esIA: bool) -> void:
	enCombate = true
	atacante = a
	defensor = d
	destinoAtacante = destino
	mostrarUI = esIA

	posicionDefensor = defensor.posicionCuadricula
	direccionImpacto = gestorMovimiento._obtenerPaso(atacante.posicionCuadricula, posicionDefensor)

	casillasValidas.clear()
	terreno.limpiarMovimiento()

	for dir: Vector2i in Constantes.DIRECCIONES_CARDINALES:
		if dir == direccionImpacto:
			continue

		posicionEmpuje = posicionDefensor + dir

		if not terreno.comprobarDentroDelMapa(posicionEmpuje):
			continue

		ocupante = terreno.getOcupante(posicionEmpuje)

		if ocupante != null and ocupante != atacante:
			continue

		casillasValidas.append(posicionEmpuje)

		if mostrarUI:
			terreno.casillas[posicionEmpuje].setDisponible(true)

	if casillasValidas.is_empty():
		_finalizarSinEmpuje()

func resolverEmpuje(pos: Vector2i) -> bool:
	if not casillasValidas.has(pos):
		return false

	terreno.liberarCasilla(defensor.posicionCuadricula)
	defensor.teletransportarACuadricula(pos)
	terreno.ocuparCasilla(pos, defensor)

	gestorMovimiento.ejecutarMovimiento(atacante, destinoAtacante)

	empujeResuelto.emit(atacante, destinoAtacante)

	_limpiar()
	return true

func _finalizarSinEmpuje() -> void:
	if terreno.comprobarCasillaOcupada(destinoAtacante):
		_limpiar()
		return

	gestorMovimiento.ejecutarMovimiento(atacante, destinoAtacante)

	empujeResuelto.emit(atacante, destinoAtacante)

	_limpiar()

func _limpiar() -> void:
	enCombate = false
	atacante = null
	defensor = null
	destinoAtacante = Vector2i.ZERO
	casillasValidas.clear()

func estarEnCombate() -> bool:
	return enCombate
