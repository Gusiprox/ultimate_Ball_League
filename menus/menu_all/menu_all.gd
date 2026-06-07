extends CanvasLayer

const NAV_BAR = "NavBar"
const CHAR_CARD_SIGNAL = "infoRequested"
const TIEMPO_ANIMACION_STATS : float = 0.15
const TIEMPO_ANIMACION_MENUS : float = 0.3
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0

@onready var navBar = $NavBar
@onready var menuStats = $MenuStats
@onready var conMenus = $contMenus
@onready var dicMenus = {
	navBar.SIGNAL_MENU_PLAY: $contMenus/MenuPlay,
	navBar.SIGNAL_MENU_EDIT_CHAR: $contMenus/MenuEditCharacter,
	navBar.SIGNAL_MENU_EDIT_TEAM: $contMenus/MenuEditTeam,
	navBar.SIGNAL_MENU_GACHA: $contMenus/MenuGacha,
	navBar.SIGNAL_MENU_STORE: $contMenus/MenuStore,
	navBar.SIGNAL_MENU_INVENTORY: $contMenus/MenuInventory
}

var menuActual: Control = null
var transicionando: bool = false
var posicionesIniciales = {}
var posOriginalStats: Vector2

func _ready() -> void:
	
	navBar.actualizarBotonesNavBar(navBar.SIGNAL_MENU_PLAY)
	
	menuStats.hide()
	posOriginalStats = menuStats.global_position
	
	cerrarMenus()
	
	navBar.menuRequested.connect(gestionarCambioMenu)
	menuStats.cerrarSolicitado.connect(cerrarVentanaStats)
	
	buscarCartasEnMenus()


#Gestionar menuStats

func cerrarVentanaStats():
	menuStats.hide()
	navBar.ocultarFondoStats()

func abrirVentanaStats(data: CharacterDataModel):
	navBar.mostrarFondoStats()
	menuStats._setData(data)
	GlobalMenus.animarEntrada(menuStats, posOriginalStats, true, TIEMPO_ANIMACION_STATS, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION)


#Cambiar menú desde el navBar

func gestionarCambioMenu(nombreMenu: String):
	# Si hacemos clic mientras hay animación, ignoramos pero refrescamos colores
	if transicionando:
		actualizarEstadoNavbar()
		return
	
	if dicMenus.has(nombreMenu):
		# Si hacemos clic en el menú que ya está abierto, no pasa nada
		if menuActual == dicMenus[nombreMenu]:
			return
		
		# Actualizamos colores del navbar ANTES de empezar para que se sienta rápido
		navBar.actualizarBotonesNavBar(nombreMenu)
		cambiarMenu(dicMenus[nombreMenu])

func cambiarMenu(menuNuevo: Control):
	if not menuNuevo.visible:
		posicionesIniciales[menuNuevo] = menuNuevo.global_position
	
	transicionando = true
	
	if menuActual != null:
		GlobalMenus.resetearSalidaMenu(menuActual, posicionesIniciales[menuActual])
	
	await GlobalMenus.animarEntrada(menuNuevo, posicionesIniciales[menuNuevo], false, TIEMPO_ANIMACION_MENUS, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION).finished
	
	menuActual = menuNuevo
	transicionando = false
	actualizarEstadoNavbar()

func animarSalida(menu: Control):
	GlobalMenus.resetearSalidaMenu(menu, posicionesIniciales[menu])

func actualizarEstadoNavbar():
	var nombreClave = ""
	for clave in dicMenus.keys():
		if dicMenus[clave] == menuActual:
			nombreClave = clave
			break
	if has_node(NAV_BAR):
		navBar.actualizarBotonesNavBar(nombreClave)

func cerrarMenus():
	for clave in dicMenus.keys():
		var nodo = dicMenus[clave]
		posicionesIniciales[nodo] = nodo.position
		
		# Estado inicial: solo Play se ve
		if clave == navBar.SIGNAL_MENU_PLAY:
			nodo.show()
			nodo.modulate.a = 1.0
			menuActual = nodo
		else:
			nodo.hide()
			nodo.modulate.a = 0.0

func buscarCartasEnMenus():
#	for menu in dicMenus.values():
#		# Buscamos las cartas dentro de los menús
#		for hijo in menu.find_children("*", "", true): 
#			if hijo.has_signal(CHAR_CARD_SIGNAL):
#				hijo.infoRequested.connect(abrirVentanaStats)
	EventBus.infoRequested.connect(abrirVentanaStats)
	
	
func gestionarEscPulsado() -> void:
	if has_node(NAV_BAR):
		get_node(NAV_BAR).escPresionado()
