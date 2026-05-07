extends Panel

@onready var menuUser = $marginMenu/Control/MenuUser
@onready var menuExit = $marginMenu/Control/MenuExit
@onready var menuOptions = $marginMenu/Control/MenuOptions
@onready var backgroundBlur = $marginMenu/Control/backgroundBlur

signal menu_requested(menu_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuUser.visible = false
	menuExit.visible = false
	menuOptions.visible = false
	backgroundBlur.hide()


func _on_btn_menu_user_pressed() -> void:
	menuUser.visible = !menuUser.visible
	backgroundBlur.visible = menuUser.visible

func _on_btn_exit_pressed() -> void:
	menuExit.visible = true
	menuOptions.visible = false


func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_cancel_exit_pressed() -> void:
	menuExit.visible = false


func _on_btn_sign_out_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menu_start/menu_start.tscn")
	#Faltaría que en el servidor se cerrara la sesión actual


func _on_btn_menu_play_pressed() -> void:
	menu_requested.emit("play")


func _on_btn_menu_edit_player_pressed() -> void:
	menu_requested.emit("editCharacter")


func _on_btn_menu_edit_team_pressed() -> void:
	menu_requested.emit("editTeam")


func _on_btn_menu_gacha_pressed() -> void:
	menu_requested.emit("gacha")


func _on_btn_menu_store_pressed() -> void:
	menu_requested.emit("store")


func _on_btn_options_pressed() -> void:
	menuOptions.visible = !menuOptions.visible
	menuExit.visible = false


func _on_btn_close_options_pressed() -> void:
	menuOptions.visible = false


func _on_background_blur_gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.is_pressed():
		
		if (menuUser.visible == true && menuExit.visible == true):
			menuExit.visible = false
			
		elif (menuUser.visible == true && menuOptions.visible == true):
			menuOptions.visible = false
			
		elif (menuUser.visible == true):
			menuUser.visible = false
			backgroundBlur.visible = menuUser.visible
