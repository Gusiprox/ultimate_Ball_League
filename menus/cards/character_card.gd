extends Panel

@onready var charModel = $contCharacterCard/character/SubViewport/CharacterPlaceholder

const COLOR_MOUSE_ENTER = Color(1.2, 1.2, 1.2)
const COLOR_MOUSE_EXIT = Color(1, 1, 1)

signal infoRequested()

var misDatos: Dictionary = {}

func _ready() -> void:
	pass

func _setData(data: ModelData):
	charModel._setData(data)

func _on_btn_info_pressed() -> void:
	infoRequested.emit()

func _on_gui_input(event: InputEvent) -> void:
	# Detectamos clic en cualquier parte (que no sea el botón de Equipar)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Emitimos la señal para MenuAll
			infoRequested.emit()

func _on_mouse_entered() -> void:
	modulate = COLOR_MOUSE_ENTER

func _on_mouse_exited() -> void:
	modulate = COLOR_MOUSE_EXIT
