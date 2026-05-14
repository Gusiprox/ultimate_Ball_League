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

var colorActivo = Color(1, 1, 1, 1)
var colorInactivo = Color(0.577, 0.577, 0.577, 1.0)
var submenus: Array = []
var vinculacionBotones = {
	"btnMenuPlay": "play",
	"btnMenuEditPlayer": "editCharacter",
	"btnMenuEditTeam": "editTeam",
	"btnMenuGacha": "gacha",
	"btnMenuStore": "store",
	"btnMenuInventory": "inventory"
}
var posicionesSubmenus = {}

signal menuRequested(menuName)

func _ready() -> void:
	submenus = [menuUser, menuExit, menuOptions, menuControls, backgroundBlur, blocker, blockerAll]
	_cerrar_menus()
	
	actualizar_visual_opciones(btnSound, menuSound)
	call_deferred("_guardar_posiciones_reales")

func _cerrar_menus():
	for menu in submenus:
		menu.visible = false

func _guardar_posiciones_reales():
	for m in [menuUser, menuExit, menuOptions]:
		# Guardamos la GLOBAL, que es la posición real en pantalla
		posicionesSubmenus[m] = m.global_position
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
	_cerrar_menus()

func _on_btn_sign_out_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menu_start/menu_start.tscn")
	#Faltaría que en el servidor se cerrara la sesión actual

func _on_btn_menu_play_pressed() -> void:
	menuRequested.emit("play")

func _on_btn_menu_edit_player_pressed() -> void:
	menuRequested.emit("editCharacter")

func _on_btn_menu_edit_team_pressed() -> void:
	menuRequested.emit("editTeam")

func _on_btn_menu_gacha_pressed() -> void:
	menuRequested.emit("gacha")

func _on_btn_menu_store_pressed() -> void:
	menuRequested.emit("store")

func _on_btn_menu_inventory_pressed() -> void:
	menuRequested.emit("inventory")

func _on_btn_options_pressed() -> void:
	animar_submenu(menuOptions)

func _on_btn_sonido_pressed() -> void:
	actualizar_visual_opciones(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizar_visual_opciones(btnControls, menuControls)

func _on_btn_close_options_pressed() -> void:
	_cerrar_menus()


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
			var claveAsignada = vinculacionBotones.get(boton.name, "")
			
			if claveAsignada == nombreActivo:
				boton.modulate = colorActivo
			else:
				boton.modulate = colorInactivo


func actualizar_visual_opciones(botonActivo: Button, paginaActiva: Control):
	# Ponemos ambos en color inactivo primero
	btnSound.modulate = colorInactivo
	btnControls.modulate = colorInactivo
	
	botonActivo.modulate = colorActivo
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true


#Animación de los submenús de navbar

func animar_submenu(menuObjetivo: Control):
	# 1. Cerramos otros submenús abiertos al instante
	for m in [menuUser, menuExit, menuOptions]:
		if m != menuObjetivo and m.visible:
			m.hide()
			m.position = posicionesSubmenus[m]

	# 2. Si el menú ya estaba visible, lo cerramos
	if menuObjetivo.visible:
		menuObjetivo.hide()
		menuObjetivo.position = posicionesSubmenus[menuObjetivo]
		backgroundBlur.hide()
		return

	# 3. Preparar entrada
	var posFinal = posicionesSubmenus[menuObjetivo]
	menuObjetivo.modulate.a = 0.0
	# Aplicamos el desplazamiento a la posición GLOBAL
	menuObjetivo.global_position.y = posFinal.y + 20 
	menuObjetivo.show()
	backgroundBlur.show()
	blocker.show()

	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menuObjetivo, "modulate:a", 1.0, 0.2)
	tween.tween_property(menuObjetivo, "global_position:y", posFinal.y, 0.2)
