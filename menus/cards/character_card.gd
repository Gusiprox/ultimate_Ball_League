extends Panel

@onready var charModel = $contCharacterCard/character
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

var dataSave: CharacterDataModel

const COLOR_MOUSE_ENTER = Color(1.2, 1.2, 1.2)
const COLOR_MOUSE_EXIT = Color(1, 1, 1)

var misDatos: Dictionary = {}

func _ready() -> void:
	if dataSave != null:
		charModel._setData(ModelData.new(dataSave))
		nameText.text = dataSave.name
	
	actualizarBotones()

func _setData(data: CharacterDataModel):
	dataSave = data
	if charModel != null:
		charModel._setData(ModelData.new(data))
	if nameText != null:
		nameText.text = dataSave.name

func _on_btn_info_pressed() -> void:
	EventBus.infoRequested.emit(dataSave)

func _on_gui_input(event: InputEvent) -> void:
	# Detectamos clic en cualquier parte (que no sea el botón de Equipar)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Emitimos la señal para MenuAll
			EventBus.infoRequested.emit(dataSave)

func _on_mouse_entered() -> void:
	modulate = COLOR_MOUSE_ENTER

func _on_mouse_exited() -> void:
	modulate = COLOR_MOUSE_EXIT

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


func _on_btn_equip_button_down() -> void:
	EventBus.equipCard.emit(dataSave.id)
