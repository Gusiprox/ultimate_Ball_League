extends Panel

# Definimos las señales para avisar a la navbar de lo que ha elegido el usuario
signal salidaConfirmada
signal salidaCancelada

func _on_btn_conf_exit_pressed() -> void:
	# Antes de cerrar el juego, avisamos por si el padre necesita limpiar algo
	salidaConfirmada.emit()
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	salidaCancelada.emit()
