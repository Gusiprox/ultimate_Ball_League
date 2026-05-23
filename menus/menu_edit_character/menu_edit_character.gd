extends Control
@onready var menuListChar = $MenuListChar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuListChar.visible = false


func _on_btn_change_char_pressed() -> void:
	menuListChar.visible = true


func _on_btn_close_menu_pressed() -> void:
	menuListChar.visible = false
