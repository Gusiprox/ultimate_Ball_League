extends Control

@onready var menuLogin = $panelLogin
@onready var menuCreate = $panelCreateUser
@onready var backgroundBlur = $backgroundBlur



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuLogin.visible = false
	menuCreate.visible = false
	backgroundBlur.hide()
	


func _on_btn_create_user_pressed() -> void:
	menuLogin.visible = true
	menuCreate.visible = false
	backgroundBlur.visible = true
	#Gestionar que se hayan metido todos los datos
	#Falta que se cree de verdad la cuenta


func _on_btn_start_pressed() -> void:
	menuLogin.visible = true
	backgroundBlur.visible = menuLogin.visible


func _on_btn_close_login_pressed() -> void:
	menuLogin.visible = false
	if(menuLogin.visible == false && menuCreate.visible == false):
		backgroundBlur.visible = false


func _on_btn_close_create_user_pressed() -> void:
	menuCreate.visible = false
	if(menuLogin.visible == false && menuCreate.visible == false):
		backgroundBlur.visible = false


func _on_btn_login_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menu_all/menu_all.tscn")


func _on_btn_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_open_create_user_pressed() -> void:
	menuLogin.visible = false
	menuCreate.visible = true
