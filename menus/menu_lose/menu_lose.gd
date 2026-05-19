extends Control

var menuAll = "res://menus/menu_all/menu_all.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_btn_return_menu_pressed() -> void:
	get_tree().change_scene_to_file(menuAll)
