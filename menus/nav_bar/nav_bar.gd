extends Panel

@onready var menuUser = $MenuUser
@onready var menuExit = $MenuExit


signal menu_requested(menu_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuUser.visible = false
	menuExit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_menu_user_pressed() -> void:
	menuUser.visible = !menuUser.visible


func _on_btn_exit_pressed() -> void:
	menuExit.visible = true


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
