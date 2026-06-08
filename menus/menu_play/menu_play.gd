extends Control

const escena = preload("res://game/Partido/PartidoFutbol.tscn")

func _on_btn_play_button_down() -> void:
	get_tree().change_scene_to_packed(escena)
