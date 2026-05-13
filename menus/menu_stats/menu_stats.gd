extends Panel

signal cerrar_solicitado

func _ready() -> void:
	pass 

func _on_btn_close_stats_pressed() -> void:
	cerrar_solicitado.emit()
