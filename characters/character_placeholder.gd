extends Node3D

@onready var characterModel =  $CharacterPlaceholder

var stats: Stats
var modelData: ModelData

var posicionCuadricula: Vector2i = Vector2i.ZERO
var posicionInicial: Vector2i = Vector2i.ZERO

func _ready() -> void:
	characterModel._setData(modelData)

func _setData(data: CharacterDataModel):
	stats = Stats.new(data)
	modelData = ModelData.new(data)


func teletransportarACuadricula(pos: Vector2i) -> void:
	posicionCuadricula = pos
	global_position = Vector3(
		pos.x * Constantes.TAMANO_CASILLA,
		Constantes.ALTURA_PERSONAJE,
		pos.y * Constantes.TAMANO_CASILLA
	)

func moverA(destino: Vector2i) -> void:
	var distanciaHorizontal: int = abs(destino.x - posicionCuadricula.x)
	var distanciaVertical: int = abs(destino.y - posicionCuadricula.y)

	if distanciaHorizontal != 0 and distanciaVertical != 0:
		return

	if distanciaHorizontal + distanciaVertical <= stats.fuerzaEmpuje:
		posicionCuadricula = destino
		teletransportarACuadricula(destino)
