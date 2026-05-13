extends Panel

@onready var menuUser = $marginMenu/Control/MenuUser
@onready var menuExit = $marginMenu/Control/MenuExit
@onready var menuOptions = $marginMenu/Control/MenuOptions
@onready var menuSound = $marginMenu/Control/MenuOptions/MenuSound
@onready var menuControls = $marginMenu/Control/MenuOptions/MenuControls
@onready var backgroundBlur = $marginMenu/Control/backgroundBlur
@onready var btnSound = $marginMenu/Control/MenuOptions/marginMenuOpt/contMenuOptBtn/btnSonido
@onready var btnControls = $marginMenu/Control/MenuOptions/marginMenuOpt/contMenuOptBtn/btnControls

@onready var blocker = $blocker
@onready var blockerAll = $blockerAll


var color_activo = Color(1, 1, 1, 1)
var color_inactivo = Color(0.577, 0.577, 0.577, 1.0)

var vinculacion_botones = {
	"btnMenuPlay": "play",
	"btnMenuEditPlayer": "editCharacter",
	"btnMenuEditTeam": "editTeam",
	"btnMenuGacha": "gacha",
	"btnMenuStore": "store",
	"btnMenuInventory": "inventory"
}

var posiciones_submenus = {}

signal menu_requested(menu_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuUser.visible = false
	menuExit.visible = false
	menuOptions.visible = false
	menuSound.visible = true
	menuControls.visible = false
	backgroundBlur.hide()
	blocker.hide()
	blockerAll.hide()
	
	actualizar_visual_opciones(btnSound, menuSound)
	call_deferred("_guardar_posiciones_reales")

func _guardar_posiciones_reales():
	for m in [menuUser, menuExit, menuOptions]:
		# Guardamos la GLOBAL, que es la posición real en pantalla
		posiciones_submenus[m] = m.global_position
		m.hide()


# --- FUNCIONES AÑADIDAS PARA MENU ALL ---

func mostrar_fondo_stats():
	backgroundBlur.show()
	blockerAll.show()

func ocultar_fondo_stats():
	backgroundBlur.hide()
	blockerAll.hide()

# ---------------------------------------


func _on_btn_menu_user_pressed() -> void:
	animar_submenu(menuUser)
	
	if (blocker.visible == true):
		blocker.visible = false

func _on_btn_exit_pressed() -> void:
	animar_submenu(menuExit)

func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	menuExit.visible = false
	backgroundBlur.visible = false
	blocker.visible = false

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
	menu_requested.emit("inventory")

func _on_btn_options_pressed() -> void:
	animar_submenu(menuOptions)

func _on_btn_sonido_pressed() -> void:
	actualizar_visual_opciones(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizar_visual_opciones(btnControls, menuControls)

func _on_btn_close_options_pressed() -> void:
	menuOptions.visible = false
	backgroundBlur.visible = false
	menuSound.visible = false
	blocker.visible = false


#Fondo difuminado al abrir menuUser

func _on_background_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		
		if menuExit.visible or menuOptions.visible:
			return
		
		if get_parent().has_method("_on_cerrar_ventana_stats"):
			get_parent()._on_cerrar_ventana_stats()
		
		if menuUser.visible:
			menuUser.visible = false
			backgroundBlur.visible = false
			blocker.visible = false


#Cambio de foco al hacer clic en un botón

func actualizar_botones_visuales(nombreActivo: String):
	# Buscamos en el contenedor donde están los botones
	var contenedor = $marginNavBar/contNavBarElements/contNavBarButtons
	
	for boton in contenedor.get_children():
		if boton is Button or boton is TextureButton:
			# Miramos en el diccionario qué "clave" tiene este botón
			var clave_asignada = vinculacion_botones.get(boton.name, "")
			
			if clave_asignada == nombreActivo:
				boton.modulate = color_activo
			else:
				boton.modulate = color_inactivo


func actualizar_visual_opciones(botonActivo: Button, paginaActiva: Control):
	# Ponemos ambos en color inactivo primero
	btnSound.modulate = color_inactivo
	btnControls.modulate = color_inactivo
	
	botonActivo.modulate = color_activo
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true
	

#Animación de los submenús de navbar

func animar_submenu(menuObjetivo: Control):
	# 1. Cerramos otros submenús abiertos al instante
	for m in [menuUser, menuExit, menuOptions]:
		if m != menuObjetivo and m.visible:
			m.hide()
			m.position = posiciones_submenus[m]

	# 2. Si el menú ya estaba visible, lo cerramos (comportamiento de "toggle")
	if menuObjetivo.visible:
		menuObjetivo.hide()
		menuObjetivo.position = posiciones_submenus[menuObjetivo]
		backgroundBlur.hide()
		return

	# 3. Preparar entrada
	var pos_final = posiciones_submenus[menuObjetivo]
	menuObjetivo.modulate.a = 0.0
	# Aplicamos el desplazamiento a la posición GLOBAL
	menuObjetivo.global_position.y = pos_final.y + 20 
	menuObjetivo.show()
	backgroundBlur.show()
	blocker.show()

	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menuObjetivo, "modulate:a", 1.0, 0.2)
	tween.tween_property(menuObjetivo, "global_position:y", pos_final.y, 0.2)
