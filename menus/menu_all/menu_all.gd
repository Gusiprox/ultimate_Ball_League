extends CanvasLayer

@onready var dic_menus = {
	"play": $contMenus/MenuPlay,
	"editCharacter": $contMenus/MenuEditCharacter,
	"editTeam": $contMenus/MenuEditTeam,
	"gacha": $contMenus/MenuGacha,
	"store": $contMenus/MenuStore
}

@onready var menuStats = $MenuStats
@onready var navBar = $NavBar


var menu_actual: Control = null
var transicionando: bool = false
var posiciones_iniciales = {}
var pos_original_stats: Vector2

func _ready() -> void:
	
	menuStats.visible = false
	pos_original_stats = menuStats.global_position
	
	# 1. Guardamos las posiciones originales de TODO antes de mover nada
	for clave in dic_menus.keys():
		var nodo = dic_menus[clave]
		posiciones_iniciales[nodo] = nodo.position
		
		# Estado inicial: solo Play se ve
		if clave == "play":
			nodo.show()
			nodo.modulate.a = 1.0
			menu_actual = nodo
		else:
			nodo.hide()
			nodo.modulate.a = 0.0
		
	navBar.menu_requested.connect(_gestionar_cambio_de_menu)
	menuStats.cerrar_solicitado.connect(_on_cerrar_ventana_stats)
	
	for menu in dic_menus.values():
		# Buscamos CUALQUIER nodo dentro de los menús
		for hijo in menu.find_children("*", "", true): 
			# Si el nodo tiene la señal de la carta, le "tiramos el cable"
			if hijo.has_signal("info_requested"):
				hijo.info_requested.connect(_on_abrir_stats)

func _on_cerrar_ventana_stats():
	menuStats.hide()
	navBar.ocultar_fondo_stats()

func _on_abrir_stats():
	
	# 2. Mostramos los fondos en la NavBar
	navBar.mostrar_fondo_stats()
	
	# 3. Preparamos la animación (igual que en animar_submenu)
	menuStats.modulate.a = 0.0
	# Lo movemos 20 píxeles hacia abajo antes de empezar
	menuStats.global_position.y = pos_original_stats.y + 20 
	menuStats.show()

	# 4. Creamos el Tween
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animamos opacidad y posición al mismo tiempo
	tween.tween_property(menuStats, "modulate:a", 1.0, 0.15)
	tween.tween_property(menuStats, "global_position:y", pos_original_stats.y, 0.15)

func _gestionar_cambio_de_menu(nombre_menu: String):
	# Si clicamos mientras hay animación, ignoramos pero refrescamos colores
	if transicionando:
		actualizar_estado_navbar()
		return
	
	if dic_menus.has(nombre_menu):
		# Si clicamos en el menú que ya está abierto, no hacemos nada
		if menu_actual == dic_menus[nombre_menu]:
			return
		
		# Actualizamos colores del navbar ANTES de empezar para que se sienta rápido
		navBar.actualizar_botones_visuales(nombre_menu)
		cambiar_menu(dic_menus[nombre_menu])

func cambiar_menu(menu_nuevo: Control):
	transicionando = true
	
	# 1. SALIDA (Instantánea)
	if menu_actual != null:
		animar_salida(menu_actual)
	
	# 2. PREPARAR ENTRADA
	var pos_final = posiciones_iniciales[menu_nuevo]
	menu_nuevo.modulate.a = 0.0
	menu_nuevo.position.y = pos_final.y + 30 
	menu_nuevo.show()
	
	# 3. ANIMAR ENTRADA (0.5s)
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu_nuevo, "modulate:a", 1.0, 0.35)
	tween.tween_property(menu_nuevo, "position:y", pos_final.y, 0.35)
	
	# 4. FINALIZACIÓN
	tween.set_parallel(false)
	tween.tween_callback(func():
		menu_actual = menu_nuevo
		transicionando = false
		actualizar_estado_navbar()
	)

func animar_salida(menu: Control):
	menu.hide()
	menu.position = posiciones_iniciales[menu]

func actualizar_estado_navbar():
	var nombre_clave = ""
	for clave in dic_menus.keys():
		if dic_menus[clave] == menu_actual:
			nombre_clave = clave
			break
	if has_node("NavBar"):
		$NavBar.actualizar_botones_visuales(nombre_clave)
