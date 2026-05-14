extends CanvasLayer

@onready var navBar = $NavBar

@onready var dicMenus = {
	navBar.signalMenuPlay: $contMenus/MenuPlay,
	navBar.signalMenuEditChar: $contMenus/MenuEditCharacter,
	navBar.signalMenuEditTeam: $contMenus/MenuEditTeam,
	navBar.signalMenuGacha: $contMenus/MenuGacha,
	navBar.signalMenuStore: $contMenus/MenuStore,
	navBar.signalMenuInventoy: $contMenus/MenuInventory
}

@onready var menuStats = $MenuStats

var menuActual: Control = null
var transicionando: bool = false
var posicionesIniciales = {}
var posOriginalStats: Vector2

func _ready() -> void:
	
	navBar.actualizarBotonesVisuales(navBar.signalMenuPlay)
	
	menuStats.visible = false
	posOriginalStats = menuStats.global_position
	
	# 1. Guardamos las posiciones originales de TODO antes de mover nada
	for clave in dicMenus.keys():
		var nodo = dicMenus[clave]
		posicionesIniciales[nodo] = nodo.position
		
		# Estado inicial: solo Play se ve
		if clave == navBar.signalMenuPlay:
			nodo.show()
			nodo.modulate.a = 1.0
			menuActual = nodo
		else:
			nodo.hide()
			nodo.modulate.a = 0.0
		
	navBar.menuRequested.connect(gestionarCambioMenu)
	menuStats.cerrarSolicitado.connect(cerrarVentanaStats)
	
	for menu in dicMenus.values():
		# Buscamos las cartas
		for hijo in menu.find_children("*", "", true): 
			if hijo.has_signal("infoRequested"):
				hijo.infoRequested.connect(abrirVentanaStats)


#Gestionar menuStats

func cerrarVentanaStats():
	menuStats.hide()
	navBar.ocultarFondoStats()

func abrirVentanaStats():
	
	navBar.mostrarFondoStats()
	
	menuStats.modulate.a = 0.0
	menuStats.global_position.y = posOriginalStats.y + 20 
	menuStats.show()

	# 4. Creamos el Tween
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animamos opacidad y posición al mismo tiempo
	tween.tween_property(menuStats, "modulate:a", 1.0, 0.15)
	tween.tween_property(menuStats, "global_position:y", posOriginalStats.y, 0.15)


#Cambiar menú desde el navBar

func gestionarCambioMenu(nombreMenu: String):
	# Si clicamos mientras hay animación, ignoramos pero refrescamos colores
	if transicionando:
		actualizarEstadoNavbar()
		return
	
	if dicMenus.has(nombreMenu):
		# Si clicamos en el menú que ya está abierto, no hacemos nada
		if menuActual == dicMenus[nombreMenu]:
			return
		
		# Actualizamos colores del navbar ANTES de empezar para que se sienta rápido
		navBar.actualizarBotonesVisuales(nombreMenu)
		cambiarMenu(dicMenus[nombreMenu])

func cambiarMenu(menuNuevo: Control):
	transicionando = true
	
	# 1. SALIDA (Instantánea)
	if menuActual != null:
		animarSalida(menuActual)
	
	# 2. PREPARAR ENTRADA
	var posFinal = posicionesIniciales[menuNuevo]
	menuNuevo.modulate.a = 0.0
	menuNuevo.position.y = posFinal.y + 20
	menuNuevo.show()
	
	# 3. ANIMAR ENTRADA
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(menuNuevo, "modulate:a", 1.0, 0.3)
	tween.tween_property(menuNuevo, "position:y", posFinal.y, 0.3)
	
	# 4. FINALIZACIÓN
	tween.set_parallel(false)
	tween.tween_callback(func():
		menuActual = menuNuevo
		transicionando = false
		actualizarEstadoNavbar()
	)

func animarSalida(menu: Control):
	menu.hide()
	menu.position = posicionesIniciales[menu]

func actualizarEstadoNavbar():
	var nombreClave = ""
	for clave in dicMenus.keys():
		if dicMenus[clave] == menuActual:
			nombreClave = clave
			break
	if has_node("NavBar"):
		navBar.actualizarBotonesVisuales(nombreClave)
