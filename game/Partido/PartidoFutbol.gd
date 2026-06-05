extends Node3D

const POSICIONES_INICIALES: Array[Vector2i] = [
	Vector2i(2, 3),
	Vector2i(4, 3),
	Vector2i(6, 3),
	Vector2i(2, 10),
	Vector2i(4, 10),
	Vector2i(6, 10)
]

@export var partidoIA: bool = true
@export var escenaNivel: PackedScene
@export var escenasPersonajes: Array[PackedScene]


var nivel: Node3D
var terreno: Node3D
var personajes: Array[CharacterBody3D] = []

var gestorTurnos: GestorTurnos
var gestorMovimiento: GestorMovimiento
var gestorCombate: GestorCombate
var gestorPuntuacion: GestorPuntuacion
var gestorIA: GestorIA

func _ready() -> void:
	nivel = escenaNivel.instantiate()
	add_child(nivel)

	_instanciarPersonajes()

	gestorTurnos = GestorTurnos.new()

	call_deferred("_iniciarPartida")

func _instanciarPersonajes() -> void:
	var mitad: int = escenasPersonajes.size() / 2

	for i: int in range(escenasPersonajes.size()):
		var personaje: CharacterBody3D = escenasPersonajes[i].instantiate()
		personaje.stats = personaje.stats.duplicate(true)

		personaje.stats.equipo = (
			Constantes.EQUIPO_AZUL.capitalize()
			if i < mitad
			else Constantes.EQUIPO_ROJO.capitalize()
		)

		add_child(personaje)
		personaje.actualizarColorEquipo()
		personajes.append(personaje)

func _iniciarPartida() -> void:
	terreno = nivel.get_node("Terreno")

	gestorMovimiento = GestorMovimiento.new(terreno)
	gestorCombate = GestorCombate.new(terreno, gestorMovimiento)
	gestorPuntuacion = GestorPuntuacion.new(terreno)
	gestorIA = GestorIA.new(self, terreno, gestorMovimiento, gestorCombate, gestorTurnos)

	gestorCombate.empujeResuelto.connect(_gestionarEmpuje)
	gestorPuntuacion.golMarcado.connect(_actualizarGolMarcado)
	gestorPuntuacion.partidoFinalizado.connect(_anunciarFinPartido)

	for i: int in range(personajes.size()):
		var pos: Vector2i = POSICIONES_INICIALES[i]
		var p: CharacterBody3D = personajes[i]

		p.posicionInicial = pos
		p.teletransportarACuadricula(pos)
		terreno.ocuparCasilla(pos, p)

	gestorTurnos.iniciar(personajes)
	gestorTurnos.turnoCambiado.connect(_gestionarCambioTurno)

	for casilla: Casilla in terreno.casillas.values():
		casilla.casillaClickeada.connect(_gestionarCasillaSeleccionada)

func _gestionarCambioTurno(personaje: CharacterBody3D) -> void:
	if personaje == null or gestorPuntuacion.terminado:
		return

	var bloquear: bool = esTurnoIA()

	for casilla: Casilla in terreno.casillas.values():
		casilla.setBloqueada(bloquear)

	gestorPuntuacion.incrementarTurno()

	if gestorPuntuacion.comprobarFinPartido():
		return

	if not esTurnoIA():
		terreno.mostrarMovimiento(personaje.posicionCuadricula, personaje.stats.fuerzaEmpuje)
	else:
		terreno.limpiarMovimiento()

	if partidoIA and personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO:
		var personajeTurno := personaje

		await get_tree().create_timer(0.5).timeout

		if gestorTurnos.getPersonajeActual() != personajeTurno:
			return

		gestorIA.jugarTurno(personajeTurno)

func _gestionarCasillaSeleccionada(pos: Vector2i) -> void:
	if gestorPuntuacion.terminado:
		return

	if gestorCombate.estaEnCombate():
		if gestorCombate.resolverEmpuje(pos):
			gestorTurnos.terminarTurno()
		return

	var personaje: CharacterBody3D = gestorTurnos.getPersonajeActual()
	if personaje == null:
		return

	if not gestorMovimiento.comprobarMovimientoValido(personaje.posicionCuadricula, pos, personaje.stats.fuerzaEmpuje):
		return

	var colision: Dictionary = gestorMovimiento.detectarColision(personaje.posicionCuadricula, pos, personaje)

	if colision.get("bloqueado", false):
		return

	if colision.enemigo == null:
		if terreno.comprobarCasillaOcupada(pos):
			return

		ejecutarMovimientoConPuntuacion(personaje, pos)
		gestorTurnos.terminarTurno()
		return

	var fuerza: int = personaje.stats.fuerzaEmpuje - colision.casillasHasta
	var resistencia: int = colision.enemigo.stats.resistenciaEmpuje

	if fuerza <= resistencia:
		return

	var esIA: bool = partidoIA and personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO

	gestorCombate.iniciarSeleccionEmpuje(personaje, colision.enemigo, pos, not esIA)

	if esIA:
		await get_tree().create_timer(0.3).timeout

		if gestorTurnos.getPersonajeActual() != personaje:
			return

		var empuje: Vector2i = gestorIA.elegirEmpuje()

		if empuje != Vector2i.ZERO and gestorCombate.estaEnCombate():
			gestorCombate.resolverEmpuje(empuje)

func _gestionarEmpuje(atacante: CharacterBody3D, _destino: Vector2i) -> void:
	gestorPuntuacion.comprobarPunto(atacante)
	gestorTurnos.terminarTurno()

func _actualizarGolMarcado(equipo: String, azules: int, rojos: int) -> void:
	print(Constantes.MSG_GOL.format({"equipo": equipo.to_upper(), "azules": azules, "rojos": rojos}))

func _anunciarFinPartido(resultado: String, azules: int, rojos: int) -> void:
	print(Constantes.MSG_FINAL.format({"resultado": resultado.to_upper(), "azules": azules, "rojos": rojos}))

func esTurnoIA() -> bool:
	var personaje: CharacterBody3D = gestorTurnos.getPersonajeActual()

	if personaje == null:
		return false

	return partidoIA and personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO

func ejecutarMovimientoConPuntuacion(personaje: CharacterBody3D, destino: Vector2i) -> void:
	gestorMovimiento.ejecutarMovimiento(personaje, destino)
	gestorPuntuacion.comprobarPunto(personaje)
