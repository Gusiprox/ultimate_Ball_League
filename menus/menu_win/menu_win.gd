extends Control

const MENU_ALL = "res://menus/menu_all/menu_all.tscn"

func _ready() -> void:
	pass

func _on_btn_return_menu_pressed() -> void:
	get_tree().change_scene_to_file(MENU_ALL)
