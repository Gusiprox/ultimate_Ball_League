class_name GestorPuntuacion

signal golMarcado(equipo: String, azules: int, rojos: int)
signal partidoFinalizado(resultado: String, azules: int, rojos: int)

var equipoJugador: String
var res: String

var puntosAzul: int = 0
var puntosRojo: int = 0
var turnos: int = 0

var prorroga: bool = false
var terminado: bool = false

var posicionJugador: Vector2i
var destino: Vector2i

var terreno: Node3D

func _init(t: Node3D) -> void:
	terreno = t

func comprobarPunto(personaje: CharacterBody3D) -> void:
	if personaje == null or personaje.stats == null:
		return

	equipoJugador = personaje.stats.equipo.to_lower()
	posicionJugador = personaje.posicionCuadricula

	if equipoJugador == Constantes.EQUIPO_AZUL and posicionJugador.y == Constantes.LINEA_GOL_AZUL:
		puntosAzul += 1
		golMarcado.emit(Constantes.EQUIPO_AZUL, puntosAzul, puntosRojo)
		_reiniciar(personaje)

	elif equipoJugador == Constantes.EQUIPO_ROJO and posicionJugador.y == Constantes.LINEA_GOL_ROJO:
		puntosRojo += 1
		golMarcado.emit(Constantes.EQUIPO_ROJO, puntosAzul, puntosRojo)
		_reiniciar(personaje)

func _reiniciar(personaje: CharacterBody3D) -> void:
	terreno.liberarCasilla(personaje.posicionCuadricula)
	destino = terreno.buscarCasillaLibreCercana(personaje.posicionInicial)
	personaje.teletransportarACuadricula(destino)
	terreno.ocuparCasilla(destino, personaje)

func incrementarTurno() -> void:
	turnos += 1

func comprobarFinPartido() -> bool:
	if not prorroga and turnos >= Constantes.TURNOS_PARTIDO:
		if puntosAzul != puntosRojo:
			_finalizar(puntosAzul > puntosRojo)
			return true
		prorroga = true
		turnos = 0

	if prorroga:
		if puntosAzul != puntosRojo:
			_finalizar(puntosAzul > puntosRojo)
			return true
		if turnos >= Constantes.TURNOS_PRORROGA:
			_declararEmpate()
			return true

	return false

func _finalizar(azulGana: bool) -> void:
	terminado = true
	terreno.limpiarMovimiento()

	res = Constantes.EQUIPO_AZUL if azulGana else Constantes.EQUIPO_ROJO
	partidoFinalizado.emit(res, puntosAzul, puntosRojo)

func _declararEmpate() -> void:
	terminado = true
	terreno.limpiarMovimiento()
	partidoFinalizado.emit(Constantes.MSG_EMPATE, puntosAzul, puntosRojo)
