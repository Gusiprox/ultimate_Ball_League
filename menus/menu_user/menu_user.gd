extends Panel

signal abrirOpcionesSolicitado
signal abrirSalirSolicitado

@onready var lblUserName: Label = $marginMenuUser/contMenuUserBtn/lblUserName

func _ready() -> void:
	if PlayerData and "username" in PlayerData:
		lblUserName.text = str(PlayerData.username)
	else:
		lblUserName.text = "Invitado"


# --- BOTONES ---

func _on_btn_options_pressed() -> void:
	abrirOpcionesSolicitado.emit()

func _on_btn_exit_pressed() -> void:
	abrirSalirSolicitado.emit()

func _on_btn_sign_out_pressed() -> void:
	const PATH_MENU_START = "res://menus/menu_start/menu_start.tscn"
	get_tree().change_scene_to_file(PATH_MENU_START)
