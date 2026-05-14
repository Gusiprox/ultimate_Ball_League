extends Panel

@onready var menuUser = $marginMenu/Control/MenuUser
@onready var menuExit = $marginMenu/Control/MenuExit
@onready var menuOptions = $marginMenu/Control/MenuOptions
@onready var menuSound = $marginMenu/Control/MenuOptions/MenuSound
@onready var menuControls = $marginMenu/Control/MenuOptions/MenuControls
@onready var backgroundBlur = $marginMenu/Control/backgroundBlur
@onready var btnSound = $marginMenu/Control/MenuOptions/marginMenuOpt/contMenuOptBtn/btnSonido
@onready var btnControls = $marginMenu/Control/MenuOptions/marginMenuOpt/contMenuOptBtn/btnControls
@onready var contNavBarButtons = $marginNavBar/contNavBarElements/contNavBarButtons
@onready var blocker = $blocker
@onready var blockerAll = $blockerAll

var colorActivo = Color(1, 1, 1, 1)
var colorInactivo = Color(0.577, 0.577, 0.577, 1.0)
var submenus: Array = []
var pathMenuStart = "res://menus/menu_start/menu_start.tscn"

var signalMenuPlay = "play"
var signalMenuEditChar = "editCharacter"
var signalMenuEditTeam = "editTeam"
var signalMenuGacha = "gacha"
var signalMenuStore = "store"
var signalMenuInventoy = "inventory"

var vinculacionBotones = {
	"btnMenuPlay": signalMenuPlay,
	"btnMenuEditPlayer": signalMenuEditChar,
	"btnMenuEditTeam": signalMenuEditTeam,
	"btnMenuGacha": signalMenuGacha,
	"btnMenuStore": signalMenuStore,
	"btnMenuInventory": signalMenuInventoy
}
var posicionesSubmenus = {}

signal menuRequested(menuName)

func _ready() -> void:
	submenus = [menuUser, menuExit, menuOptions, menuControls, backgroundBlur, blocker, blockerAll]
	cerrarMenus()
	
	actualizarVisualOpciones(btnSound, menuSound)
	call_deferred("guardarPosicionesReales")


#Cerrar todos los menús (menus menuSound)

func cerrarMenus():
	for menu in submenus:
		menu.visible = false


#Guardar posiciones iniciales de los menús para que no se desplacen con el tween

func guardarPosicionesReales():
	for m in [menuUser, menuExit, menuOptions]:
		posicionesSubmenus[m] = m.global_position
		m.hide()


# Funciones usadas para poner o quitar el blur y block

func mostrarFondoStats():
	backgroundBlur.show()
	blockerAll.show()

func ocultarFondoStats():
	backgroundBlur.hide()
	blockerAll.hide()


# --- BOTONES ---

func _on_btn_menu_user_pressed() -> void:
	animarSubmenu(menuUser)
	
	if (blocker.visible == true):
		blocker.visible = false

func _on_btn_exit_pressed() -> void:
	animarSubmenu(menuExit)

func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	cerrarMenus()

func _on_btn_sign_out_pressed() -> void:
	get_tree().change_scene_to_file(pathMenuStart)
	#Faltaría que en el servidor se cerrara la sesión actual

func _on_btn_menu_play_pressed() -> void:
	menuRequested.emit(signalMenuPlay)

func _on_btn_menu_edit_player_pressed() -> void:
	menuRequested.emit(signalMenuEditChar)

func _on_btn_menu_edit_team_pressed() -> void:
	menuRequested.emit(signalMenuEditTeam)

func _on_btn_menu_gacha_pressed() -> void:
	menuRequested.emit(signalMenuGacha)

func _on_btn_menu_store_pressed() -> void:
	menuRequested.emit(signalMenuStore)

func _on_btn_menu_inventory_pressed() -> void:
	menuRequested.emit(signalMenuInventoy)

func _on_btn_options_pressed() -> void:
	animarSubmenu(menuOptions)

func _on_btn_sonido_pressed() -> void:
	actualizarVisualOpciones(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizarVisualOpciones(btnControls, menuControls)

func _on_btn_close_options_pressed() -> void:
	cerrarMenus()


#Fondo difuminado al abrir menuUser

func _on_background_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		
		if menuExit.visible or menuOptions.visible:
			return
		
		if get_parent().has_method("cerrarVentanaStats"):
			get_parent().cerrarVentanaStats()
		
		if menuUser.visible:
			menuUser.visible = false
			backgroundBlur.visible = false
			blocker.visible = false


#Cambio de botón marcado en los botones de navBar

func actualizarBotonesVisuales(nombreActivo: String):
	# Buscamos en el contenedor donde están los botones
	var contenedor = contNavBarButtons
	
	for boton in contenedor.get_children():
		if boton is Button or boton is TextureButton:
			# Miramos en el diccionario qué "clave" tiene este botón
			var claveAsignada = vinculacionBotones.get(boton.name, "")
			
			if claveAsignada == nombreActivo:
				boton.modulate = colorActivo
			else:
				boton.modulate = colorInactivo


#Cambio de botón marcado en menuOptions

func actualizarVisualOpciones(botonActivo: Button, paginaActiva: Control):
	btnSound.modulate = colorInactivo
	btnControls.modulate = colorInactivo
	
	botonActivo.modulate = colorActivo
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true


#Animación de los submenús de navbar

func animarSubmenu(menuObjetivo: Control):
	for m in [menuUser, menuExit, menuOptions]:
		if m != menuObjetivo and m.visible:
			m.hide()
			m.position = posicionesSubmenus[m]

	if menuObjetivo.visible:
		menuObjetivo.hide()
		menuObjetivo.position = posicionesSubmenus[menuObjetivo]
		backgroundBlur.hide()
		return

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
