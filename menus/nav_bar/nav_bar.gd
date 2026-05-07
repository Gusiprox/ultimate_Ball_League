extends Panel

@onready var menuUser = $marginMenu/Control/MenuUser
@onready var menuExit = $marginMenu/Control/MenuExit
@onready var menuOptions = $marginMenu/Control/MenuOptions
@onready var backgroundBlur = $marginMenu/Control/backgroundBlur

var color_activo = Color(1, 1, 1, 1)
var color_inactivo = Color(0.634, 0.634, 0.634, 1.0)

var vinculacion_botones = {
	"btnMenuPlay": "play",
	"btnMenuEditPlayer": "editCharacter",
	"btnMenuEditTeam": "editTeam",
	"btnMenuGacha": "gacha",
	"btnMenuStore": "store",
}

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

func _on_btn_menu_inventory_pressed() -> void:
	#No se ha creado todavía
	pass # Replace with function body.

func _on_btn_options_pressed() -> void:
	menuOptions.visible = !menuOptions.visible
	menuExit.visible = false

func _on_btn_close_options_pressed() -> void:
	menuOptions.visible = false


#Fondo difuminado al abrir menuUser

func _on_background_blur_gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.is_pressed():
		
		if (menuUser.visible == true && menuExit.visible == true):
			menuExit.visible = false
			
		elif (menuUser.visible == true && menuOptions.visible == true):
			menuOptions.visible = false
			
		elif (menuUser.visible == true):
			menuUser.visible = false
			backgroundBlur.visible = menuUser.visible


#Cambio de foco al hacer clic en un botón

func actualizar_botones_visuales(nombre_activo: String):
	# Buscamos en el contenedor donde están los botones
	var contenedor = $marginNavBar/contNavBarElements/contNavBarButtons
	
	for boton in contenedor.get_children():
		if boton is Button or boton is TextureButton:
			# Miramos en el diccionario qué "clave" tiene este botón
			var clave_asignada = vinculacion_botones.get(boton.name, "")
			
			if clave_asignada == nombre_activo:
				boton.modulate = color_activo
				boton.mouse_default_cursor_shape = Control.CURSOR_ARROW
			else:
				boton.modulate = color_inactivo
				boton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
