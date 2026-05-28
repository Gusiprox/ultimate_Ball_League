extends Panel

const CERRAR_VENTANA_STATS = "cerrarVentanaStats"
const GUARDAR_POSICIONES_REALES = "guardarPosicionesReales"
const SIGNAL_MENU_PLAY = "play"
const SIGNAL_MENU_EDIT_CHAR = "editCharacter"
const SIGNAL_MENU_EDIT_TEAM = "editTeam"
const SIGNAL_MENU_GACHA = "gacha"
const SIGNAL_MENU_STORE = "store"
const SIGNAL_MENU_INVENTORY = "inventory"
const PATH_MENU_START = "res://menus/menu_start/menu_start.tscn"
const TIEMPO_ANIMACION : float = 0.2
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0
const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.577, 0.577, 0.577, 1.0)

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
@onready var lblPulls = $marginNavBar/contNavBarElements/contRightSide/contCoinsAndPulls/contPulls/lblPulls
@onready var lblCoins = $marginNavBar/contNavBarElements/contRightSide/contCoinsAndPulls/contCoins/lblCoins
@onready var lblUserName = $marginMenu/Control/MenuUser/marginMenuUser/contMenuUserBtn/lblUserName

var submenus: Array = []
var posicionesSubmenus = {}
var vinculacionBotones = {
	"btnMenuPlay": SIGNAL_MENU_PLAY,
	"btnMenuEditPlayer": SIGNAL_MENU_EDIT_CHAR,
	"btnMenuEditTeam": SIGNAL_MENU_EDIT_TEAM,
	"btnMenuGacha": SIGNAL_MENU_GACHA,
	"btnMenuStore": SIGNAL_MENU_STORE,
	"btnMenuInventory": SIGNAL_MENU_INVENTORY
}

signal menuRequested(menuName)

func _ready() -> void:
	
	traerDatos()
	
	submenus = [menuUser, menuExit, menuOptions, menuControls, backgroundBlur, blocker, blockerAll]
	cerrarMenus()
	
	actualizarBotonesOptions(btnSound, menuSound)
	call_deferred(GUARDAR_POSICIONES_REALES)


#Traer las tiradas, monedas y el nombre del usuario

func traerDatos():
	lblPulls.text = str(PlayerData.gacha_tokens)
	lblCoins.text = str(PlayerData.gold)
	lblUserName.text = str(PlayerData.username)
	
	PlayerData.gacha_tokens_changed.connect(onPullsCambiadas)
	PlayerData.gold_changed.connect(onCoinsCambiadas)


#Cambiar valor de tiradas y monedas

func onPullsCambiadas(nuevasPulls: int) -> void:
	lblPulls.text = str(nuevasPulls)

func onCoinsCambiadas(nuevasCoins: int) -> void:
	lblCoins.text = str(nuevasCoins)


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

func _on_btn_exit_pressed() -> void:
	animarSubmenu(menuExit)

func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	cerrarMenus()

func _on_btn_sign_out_pressed() -> void:
	get_tree().change_scene_to_file(PATH_MENU_START)
	#Faltaría que en el servidor se cerrara la sesión actual

func _on_btn_options_pressed() -> void:
	animarSubmenu(menuOptions)

func _on_btn_sonido_pressed() -> void:
	actualizarBotonesOptions(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizarBotonesOptions(btnControls, menuControls)

func _on_btn_close_options_pressed() -> void:
	cerrarMenus()

func _on_btn_menu_play_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_PLAY)

func _on_btn_menu_edit_player_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_EDIT_CHAR)

func _on_btn_menu_edit_team_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_EDIT_TEAM)

func _on_btn_menu_gacha_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_GACHA)

func _on_btn_menu_store_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_STORE)

func _on_btn_menu_inventory_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_INVENTORY)


#Al hacer clic en el fondo difuminado se cierra menuUser

func _on_background_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			return
		
		if menuExit.visible or menuOptions.visible:
			return
		
		if get_parent().has_method(CERRAR_VENTANA_STATS):
			get_parent().cerrarVentanaStats()
		
		if menuUser.visible:
			menuUser.visible = false
			backgroundBlur.visible = false
			blocker.visible = false


#Cambio de botón marcado en los botones de navBar

func actualizarBotonesNavBar(nombreActivo: String):
	for boton in contNavBarButtons.get_children():
		if boton is Button:
			# Miramos en el diccionario qué "clave" tiene este botón
			var claveAsignada = vinculacionBotones.get(boton.name, "")
			
			if claveAsignada == nombreActivo:
				boton.modulate = COLOR_ACTIVO
			else:
				boton.modulate = COLOR_INACTIVO


#Cambio de botón marcado en menuOptions

func actualizarBotonesOptions(botonActivo: Button, paginaActiva: Control):
	btnSound.modulate = COLOR_INACTIVO
	btnControls.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true


#Animación de los submenús de navbar

func animarSubmenu(menuObjetivo: Control):
	if not menuObjetivo.visible:
		posicionesSubmenus[menuObjetivo] = menuObjetivo.global_position
	
	for m in [menuUser, menuExit, menuOptions]:
		if m != menuObjetivo and m.visible:
			GlobalMenus.resetearSalidaMenu(m, posicionesSubmenus[m], true)

	if menuObjetivo.visible:
		GlobalMenus.resetearSalidaMenu(menuObjetivo, posicionesSubmenus[menuObjetivo], true)
		backgroundBlur.hide()
		blocker.hide()
		return

	backgroundBlur.show()
	blocker.show()

	GlobalMenus.animarEntrada(menuObjetivo, posicionesSubmenus[menuObjetivo], true, TIEMPO_ANIMACION, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION)
