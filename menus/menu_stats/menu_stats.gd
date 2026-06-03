extends Panel

signal cerrarSolicitado

func _ready() -> void:
	pass 

func _on_btn_close_stats_pressed() -> void:
	cerrarSolicitado.emit()
