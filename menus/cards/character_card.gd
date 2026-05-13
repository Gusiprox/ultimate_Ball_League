extends Panel

signal info_requested()

var mis_datos: Dictionary = {}

func _ready() -> void:
	pass

func _on_btn_info_pressed() -> void:
	info_requested.emit()


func _on_gui_input(event: InputEvent) -> void:
	# Detectamos clic en cualquier parte (que no sea el botón de Equipar)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Emitimos la señal para MenuAll
			info_requested.emit()


func _on_mouse_entered() -> void:
	modulate = Color(1.2, 1.2, 1.2)


func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)
