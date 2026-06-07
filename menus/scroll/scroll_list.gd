extends ScrollContainer

@export var columns: int = 4
@onready var contBox = $contListElem
const  cardMolde = preload("res://menus/cards/character_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setData(PlayerData.characters)
	contBox.columns = columns

func _setData(data: Array[CharacterDataModel]):
	_limpiarLista()
	for characterData: CharacterDataModel in data:
		var nuevaCarta = cardMolde.instantiate()
		nuevaCarta._setData(characterData)
		
		contBox.add_child(nuevaCarta)

func _limpiarLista():
	for child in contBox.get_children():
		child.queue_free()
