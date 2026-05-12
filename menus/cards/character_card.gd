extends Panel

signal info_requested()

var mis_datos: Dictionary = {}

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_btn_info_pressed() -> void:
	info_requested.emit()


func _on_gui_input(event: InputEvent) -> void:
	# Detectamos clic en cualquier parte (que no sea el botón de Equipar)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Emitimos la señal para MenuAll
			info_requested.emit()
