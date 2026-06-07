extends Node3D

const POSICIONES_INICIALES: Array[Vector2i] = [
	Vector2i(2, 3),
	Vector2i(4, 3),
	Vector2i(6, 3),
	Vector2i(2, 10),
	Vector2i(4, 10),
	Vector2i(6, 10)
]

@export var test: bool = true
@export var partidoIA: bool = true
@export var escenaNivel: PackedScene
@export var escenasPersonajes: Array[PackedScene]

var personajesJugador: Array[CharacterBody3D]
var personajesRival: Array[CharacterBody3D]
var habilidadSeleccionada: String = ""

var mitad: int
var fuerza: int
var resistencia: int

var bloquear: bool
var esIA: bool
var habilidadActivado: bool = false

var colision: Dictionary

var nivel: Node3D
var terreno: Node3D

var personaje: CharacterBody3D

var personajes: Array[CharacterBody3D] = []

var posicion: Vector2i
var empuje: Vector2i
var origen: Vector2i

var gestorTurnos: GestorTurnos
var gestorMovimiento: GestorMovimiento
var gestorCombate: GestorCombate
var gestorPuntuacion: GestorPuntuacion
var gestorHabilidades: GestorHabilidades
var gestorIA: GestorIA

func _ready() -> void:
	nivel = escenaNivel.instantiate()
	add_child(nivel)

	_instanciarPersonajes()

	gestorTurnos = GestorTurnos.new()

	call_deferred("_iniciarPartida")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_alternarHabilidad()

func _instanciarPersonajes() -> void:
	if test:
		_instanciarPersonajesTest()
		return
	
	personajesJugador = PlayerData.equipo
	personajesRival = IaDataManager._getIaTeam()
	
	for personaje in personajesJugador:
		personaje.stats.equipo = Constantes.EQUIPO_AZUL.capitalize()
		
		add_child(personaje)
		#personaje.actualizarColorEquipo()
		personajes.append(personaje)
	
	for personaje in personajesRival:
		personaje.stats.equipo = Constantes.EQUIPO_ROJO.capitalize()
		
		add_child(personaje)
		#personaje.actualizarColorEquipo()
		personajes.append(personaje)
	
func _instanciarPersonajesTest() -> void:
	var mitad: int = escenasPersonajes.size() / 2

	for i: int in range(escenasPersonajes.size()):
		personaje = escenasPersonajes[i].instantiate()
		personaje.stats = personaje.stats.duplicate(true)

		personaje.stats.equipo = (Constantes.EQUIPO_AZUL.capitalize() if i < mitad else Constantes.EQUIPO_ROJO.capitalize())

		add_child(personaje)
		personaje.actualizarColorEquipo()
		personajes.append(personaje)

func _iniciarPartida() -> void:
	terreno = nivel.get_node("Terreno")

	gestorMovimiento = GestorMovimiento.new(terreno)
	gestorCombate = GestorCombate.new(terreno, gestorMovimiento)
	gestorPuntuacion = GestorPuntuacion.new(terreno)
	gestorHabilidades = GestorHabilidades.new(terreno)
	gestorIA = GestorIA.new(self, terreno, gestorMovimiento, gestorCombate, gestorTurnos)

	gestorCombate.empujeResuelto.connect(_gestionarEmpuje)
	gestorPuntuacion.golMarcado.connect(_actualizarGolMarcado)
	gestorPuntuacion.partidoFinalizado.connect(_anunciarFinPartido)

	for i: int in range(personajes.size()):
		posicion = POSICIONES_INICIALES[i]
		personaje = personajes[i]

		personaje.posicionInicial = posicion
		personaje.teletransportarACuadricula(posicion)
		terreno.ocuparCasilla(posicion, personaje)

	gestorTurnos.iniciar(personajes)
	gestorTurnos.turnoCambiado.connect(_gestionarCambioTurno)
	gestorTurnos.turnoFinalizado.connect(_gestionarFinTurno)

	for casilla: Casilla in terreno.casillas.values():
		casilla.casillaClickeada.connect(_gestionarCasillaSeleccionada)

func _gestionarCambioTurno(p: CharacterBody3D) -> void:
	if p == null or gestorPuntuacion.terminado:
		return

	bloquear = confirmarTurnoIA()

	for casilla: Casilla in terreno.casillas.values():
		casilla.setBloqueada(bloquear)

	gestorPuntuacion.incrementarTurno()

	if gestorPuntuacion.comprobarFinPartido():
		return

	print(personaje.stats.fuerzaEmpuje)

	if not confirmarTurnoIA():
		terreno.mostrarMovimiento(p.posicionCuadricula, p.stats.fuerzaEmpuje)
	else:
		terreno.limpiarMovimiento()

	if partidoIA and p.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO:

		await get_tree().create_timer(0.5).timeout

		if gestorTurnos.getPersonajeActual() != p:
			return

		gestorIA.jugarTurno(p)

func _gestionarCasillaSeleccionada(pos: Vector2i) -> void:
	if gestorPuntuacion.terminado:
		return

	personaje = gestorTurnos.getPersonajeActual()
	
	if personaje == null:
		return

	if habilidadActivado:

		if gestorHabilidades.activar_habilidad(personaje, habilidadSeleccionada, pos):
			habilidadActivado = false
			habilidadSeleccionada = ""
			gestorTurnos.terminarTurno()

		return

	if gestorCombate.estarEnCombate():
		if gestorCombate.resolverEmpuje(pos):
			gestorTurnos.terminarTurno()
		return

	personaje = gestorTurnos.getPersonajeActual()
	if personaje == null:
		return

	if not gestorMovimiento.comprobarMovimientoValido(personaje.posicionCuadricula, pos, personaje.stats.fuerzaEmpuje):
		return

	colision = gestorMovimiento.detectarColision(personaje.posicionCuadricula, pos, personaje)

	if colision.get(Constantes.DICTIONARY_KEY_BLOQUEADO, false):
		return

	if colision[Constantes.DICTIONARY_KEY_ENEMIGO] == null:
		if terreno.comprobarCasillaOcupada(pos):
			return

		ejecutarMovimientoConPuntuacion(personaje, pos)
		gestorTurnos.terminarTurno()
		return

	fuerza = personaje.stats.fuerzaEmpuje - colision[Constantes.DICTIONARY_KEY_CASILLAS]
	resistencia = colision[Constantes.DICTIONARY_KEY_ENEMIGO].stats.resistenciaEmpuje

	if fuerza <= resistencia:
		return

	esIA = partidoIA and personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO

	gestorCombate.iniciarSeleccionEmpuje(personaje, colision[Constantes.DICTIONARY_KEY_ENEMIGO], pos, not esIA)

	if esIA:
		await get_tree().create_timer(0.3).timeout

		if gestorTurnos.getPersonajeActual() != personaje:
			return

		empuje = gestorIA.elegirEmpuje()

		if empuje != Vector2i.ZERO and gestorCombate.estarEnCombate():
			gestorCombate.resolverEmpuje(empuje)

func _gestionarEmpuje(atacante: CharacterBody3D, _destino: Vector2i) -> void:
	gestorPuntuacion.comprobarPunto(atacante)
	gestorTurnos.terminarTurno()

func _actualizarGolMarcado(equipo: String, azules: int, rojos: int) -> void:
	print(Constantes.MSG_GOL.format({"equipo": equipo.to_upper(), "azules": azules, "rojos": rojos}))

func _anunciarFinPartido(resultado: String, azules: int, rojos: int) -> void:
	print(Constantes.MSG_FINAL.format({"resultado": resultado.to_upper(), "azules": azules, "rojos": rojos}))

func confirmarTurnoIA() -> bool:
	personaje = gestorTurnos.getPersonajeActual()

	if personaje == null:
		return false

	return partidoIA and personaje.stats.equipo.to_lower() == Constantes.EQUIPO_ROJO

func ejecutarMovimientoConPuntuacion(p: CharacterBody3D, destino: Vector2i) -> void:
	gestorMovimiento.ejecutarMovimiento(p, destino)
	gestorPuntuacion.comprobarPunto(p)

func _gestionarFinTurno(p: CharacterBody3D) -> void:
	gestorHabilidades.procesarCooldownsPersonaje(p)
	gestorHabilidades.procesarFinTurnoPersonaje(p)

func _alternarHabilidad() -> void:
	personaje = gestorTurnos.getPersonajeActual()
	if personaje == null:
		return

	if personaje.stats.habilidad == "":
		return

	if habilidadActivado:
		habilidadActivado = false
		habilidadSeleccionada = ""
		terreno.mostrarMovimiento(personaje.posicionCuadricula, personaje.stats.fuerzaEmpuje)
	else:
		
		if not gestorHabilidades.comprobarUso(personaje, personaje.stats.habilidad):
			return
			
		habilidadActivado = true
		habilidadSeleccionada = personaje.stats.habilidad
		_mostrarRangoHabilidad(personaje)
		
func _mostrarRangoHabilidad(p: CharacterBody3D) -> void:
	terreno.limpiarMovimiento()

	origen = p.posicionCuadricula

	match p.stats.habilidad:

		Habilidades.ENTRENADOR:
			_mostrarCasillaAdyacente(origen)

		Habilidades.FORTALECEDOR:
			_mostrarCasillaCuadrado(origen)

		Habilidades.EMPUJON:
			_mostrarCasillaAdyacente(origen)
			
func _mostrarCasillaAdyacente(o: Vector2i) -> void:
	for d in Constantes.DIRECCIONES_CARDINALES:
		posicion = o + d
		if terreno.comprobarDentroDelMapa(posicion):
			terreno.casillas[posicion].setDisponible(true)


func _mostrarCasillaCuadrado(o: Vector2i) -> void:
	for x in range(-1, 2):
		for y in range(-1, 2):
			posicion = o + Vector2i(x, y)
			if terreno.comprobarDentroDelMapa(posicion) and posicion != o:
				terreno.casillas[posicion].setDisponible(true)
