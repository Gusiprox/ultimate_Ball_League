extends Control

@onready var menuLogin = $panelLogin
@onready var menuCreate = $panelCreateUser



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuLogin.visible = false
	menuCreate.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_btn_create_user_pressed() -> void:
	menuLogin.visible = false
	menuCreate.visible = true


func _on_btn_start_pressed() -> void:
	menuLogin.visible = true


func _on_btn_close_login_pressed() -> void:
	menuLogin.visible = false


func _on_btn_close_create_user_pressed() -> void:
	menuCreate.visible = false


func _on_btn_login_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_all/menu_all.tscn")
