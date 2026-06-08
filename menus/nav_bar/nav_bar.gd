extends Panel

const CERRAR_VENTANA_STATS = "cerrarVentanaStats"
const GUARDAR_POSICIONES_REALES = "guardarPosicionesReales"
const SIGNAL_MENU_PLAY = "play"
const SIGNAL_MENU_EDIT_TEAM = "editTeam"
const SIGNAL_MENU_GACHA = "gacha"
const SIGNAL_MENU_STORE = "store"
const SIGNAL_MENU_INVENTORY = "inventory"
const TIEMPO_ANIMACION : float = 0.2
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0
const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.577, 0.577, 0.577, 1.0)

@onready var menuUser = $marginMenu/Control/MenuUser
@onready var menuExit = $marginMenu/Control/MenuExit
@onready var menuOptions = $marginMenu/Control/MenuOptions
@onready var backgroundBlur = $marginMenu/Control/backgroundBlur
@onready var contNavBarButtons = $marginNavBar/contNavBarElements/contNavBarButtons
@onready var lblPulls = $marginNavBar/contNavBarElements/contRightSide/contCoinsAndPulls/contPulls/lblPulls
@onready var lblCoins = $marginNavBar/contNavBarElements/contRightSide/contCoinsAndPulls/contCoins/lblCoins
@onready var blocker = $blocker
@onready var blockerAll = $blockerAll

var submenus: Array = []
var submenusMenuUser: Array = []
var posicionesSubmenus = {}
var vinculacionBotones = {
	"btnMenuPlay": SIGNAL_MENU_PLAY,
	"btnMenuEditTeam": SIGNAL_MENU_EDIT_TEAM,
	"btnMenuGacha": SIGNAL_MENU_GACHA,
	"btnMenuStore": SIGNAL_MENU_STORE,
	"btnMenuInventory": SIGNAL_MENU_INVENTORY
}

signal menuRequested(menuName)

func _ready() -> void:
	
	traerDatos()
	
	submenus = [menuUser, menuExit, menuOptions, backgroundBlur, blocker, blockerAll]
	submenusMenuUser = [menuUser, menuExit, menuOptions]
	
	menuUser.abrirOpcionesSolicitado.connect(func(): animarSubmenu(menuOptions))
	menuUser.abrirSalirSolicitado.connect(func(): animarSubmenu(menuExit))
	
	menuOptions.cerradoSolicitado.connect(onMenuOptionsCerradoSolicitado)
	menuExit.salidaCancelada.connect(menuExitCancelada)
	
	cerrarMenus()
	call_deferred(GUARDAR_POSICIONES_REALES)


#Traer del servidor las tiradas, monedas y el nombre del usuario

func traerDatos():
	lblPulls.text = str(PlayerData.gacha_tokens)
	lblCoins.text = str(PlayerData.gold)
	
	PlayerData.gacha_tokens_changed.connect(onPullsCambiadas)
	PlayerData.gold_changed.connect(onCoinsCambiadas)


#Cambiar valor de tiradas y monedas

func onPullsCambiadas(nuevasPulls: int) -> void:
	lblPulls.text = str(nuevasPulls)

func onCoinsCambiadas(nuevasCoins: int) -> void:
	lblCoins.text = str(nuevasCoins)


func menuExitCancelada() -> void:
	cerrarMenuExit()

func onMenuOptionsCerradoSolicitado() -> void:
	cerrarMenuOpciones()

func cerrarMenuExit():
	if menuExit.visible:
		GlobalMenus.resetearSalidaMenu(menuExit, posicionesSubmenus[menuExit], true)
		backgroundBlur.hide()
		blocker.hide()


#Cerrar todos los menús

func cerrarMenus():
	for menu in submenus:
		menu.hide()


#Cerrar el menú de opciones

func cerrarMenuOpciones():
	menuOptions.hide()
	blocker.hide()
	backgroundBlur.hide()


#Cerrar el menú user

func cerrarMenuUser():
	menuUser.hide()
	backgroundBlur.hide()
	blocker.hide()


#Guardar posiciones iniciales de los menús para que no se desplacen con el tween

func guardarPosicionesReales():
	for m in submenusMenuUser:
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

func _on_btn_menu_play_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_PLAY)

func _on_btn_menu_edit_team_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_EDIT_TEAM)

func _on_btn_menu_gacha_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_GACHA)

func _on_btn_menu_store_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_STORE)

func _on_btn_menu_inventory_pressed() -> void:
	menuRequested.emit(SIGNAL_MENU_INVENTORY)


func escPresionado():
	animarSubmenu(menuUser)


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
			cerrarMenuUser()


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


#Animación de los submenús de navbar

func animarSubmenu(menuObjetivo: Control):
	if not menuObjetivo.visible:
		posicionesSubmenus[menuObjetivo] = menuObjetivo.global_position
	
	for m in submenusMenuUser:
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
