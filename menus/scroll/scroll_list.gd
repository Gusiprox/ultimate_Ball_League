extends ScrollContainer


@export var columns: int = 4
@export var modoActual: ModoCarta = ModoCarta.SIN_BTN
@onready var contBox = $contListElem
const  cardMolde = preload("res://menus/cards/character_card.tscn")

enum ModoCarta { SIN_BTN, BUY, EQUIP }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setData()
	contBox.columns = columns
	EventBus.reloadData.connect(_setData)

func _setData():

	var data = PlayerData.characters
	_limpiarLista()
	for characterData: CharacterDataModel in data:
		var nuevaCarta = cardMolde.instantiate()
		aplicarModoCarta(nuevaCarta)
		nuevaCarta._setData(characterData)
		
		contBox.add_child(nuevaCarta)

func _limpiarLista():
	for child in contBox.get_children():
		child.queue_free()

func aplicarModoCarta(nuevaCarta: Node):
	match modoActual:
		ModoCarta.SIN_BTN:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.SIN_BTN
		ModoCarta.BUY:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.BUY
		ModoCarta.EQUIP:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.EQUIP
