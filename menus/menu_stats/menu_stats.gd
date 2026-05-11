extends Panel

signal cerrar_solicitado

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_btn_close_stats_pressed() -> void:
	cerrar_solicitado.emit()
