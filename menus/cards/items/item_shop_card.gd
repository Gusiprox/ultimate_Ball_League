extends Panel

@onready var charModel = $ItemIcon
@onready var nameText = $contCharacterCard/contCardElem/lblName
@onready var btnEquip = $contCharacterCard/btnEquip
@onready var btnBuy = $contCharacterCard/btnBuy

var modoActual: ModoCarta = ModoCarta.SIN_BTN:
	set(nuevoModo):
		modoActual = nuevoModo
		if is_inside_tree(): 
			actualizarBotones()

# 1. Definimos los estados posibles de la carta
enum ModoCarta { SIN_BTN, BUY, EQUIP }

var dataSave: ItemData

const COLOR_MOUSE_ENTER = Color(1.2, 1.2, 1.2)
const COLOR_MOUSE_EXIT = Color(1, 1, 1)

var misDatos: Dictionary = {}

func _ready() -> void:
	if dataSave != null:
		charModel._setData(dataSave)
		nameText.text = dataSave.name
	
	actualizarBotones()

func _setData(data: ItemData):
	dataSave = data
	if charModel != null:
		charModel._setData(data)
	if nameText != null:
		nameText.text = dataSave.name



func actualizarBotones():
	match modoActual:
		ModoCarta.SIN_BTN:
			btnBuy.visible = false
			btnEquip.visible = false
			
		ModoCarta.BUY:
			btnBuy.visible = true
			btnEquip.visible = false
			
		ModoCarta.EQUIP:
			btnBuy.visible = false
			btnEquip.visible = true


func _on_btn_buy_button_down() -> void:
	EventBus.buyItem.emit(dataSave)
