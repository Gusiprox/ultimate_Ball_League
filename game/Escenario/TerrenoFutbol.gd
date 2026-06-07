extends Node3D

@export var escenaCasilla: PackedScene

var diferenciaX: int
var diferenciaY: int
var distanciaManhattan: int

var posicion: Vector2i
var actual: Vector2i
var nueva: Vector2i

var casillas: Dictionary = {}
var ocupacion: Dictionary = {}
var visitadas: Dictionary = {}

var cola: Array[Vector2i]

var casilla: Casilla

func _ready() -> void:
	_generarTerreno()

func _generarTerreno() -> void:
	for x: int in range(Constantes.ANCHO_MAPA):
		for y: int in range(Constantes.LARGO_MAPA):
			casilla = escenaCasilla.instantiate()
			add_child(casilla)

			posicion = Vector2i(x, y)
			casilla.posicionCuadricula = posicion
			casilla.position = Vector3(x * Constantes.TAMANO_CASILLA, 0, y * Constantes.TAMANO_CASILLA)

			casillas[posicion] = casilla

func ocuparCasilla(pos: Vector2i, personaje: CharacterBody3D) -> void:
	ocupacion[pos] = personaje

func liberarCasilla(pos: Vector2i) -> void:
	ocupacion.erase(pos)

func comprobarCasillaOcupada(pos: Vector2i) -> bool:
	return ocupacion.has(pos)

func limpiarMovimiento() -> void:
	for c: Casilla in casillas.values():
		c.setDisponible(false)

func mostrarMovimiento(origen: Vector2i, alcance: int) -> void:
	limpiarMovimiento()

	for posicionDestino: Vector2i in casillas.keys():
		diferenciaX = abs(posicionDestino.x - origen.x)
		diferenciaY = abs(posicionDestino.y - origen.y)

		if diferenciaX != 0 and diferenciaY != 0:
			continue

		distanciaManhattan = diferenciaX + diferenciaY

		if distanciaManhattan > 0 and distanciaManhattan <= alcance:
			casillas[posicionDestino].setDisponible(true)

func comprobarDentroDelMapa(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < Constantes.ANCHO_MAPA and pos.y >= 0 and pos.y < Constantes.LARGO_MAPA

func buscarCasillaLibreCercana(origen: Vector2i) -> Vector2i:
	if comprobarDentroDelMapa(origen) and not comprobarCasillaOcupada(origen):
		return origen

	cola = [origen]
	visitadas[origen] = true

	while cola.size() > 0:
		actual = cola.pop_front()
		
		for dir: Vector2i in Constantes.DIRECCIONES_CARDINALES:
			nueva = actual + dir

			if visitadas.has(nueva):
				continue
			visitadas[nueva] = true
			if not comprobarDentroDelMapa(nueva):
				continue
			if not comprobarCasillaOcupada(nueva):
				return nueva
			cola.append(nueva)
	return origen

func getOcupante(pos: Vector2i) -> CharacterBody3D:
	return ocupacion.get(pos, null)
