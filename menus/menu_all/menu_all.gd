extends CanvasLayer

var menu_actual: Control = null

@onready var dic_menus = {
	"play": $Control/MenuPlay,
	"editCharacter": $Control/MenuEditCharacter,
	"editTeam": $Control/MenuEditTeam,
	"gacha": $Control/MenuGacha,
	"store": $Control/MenuStore
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for clave in dic_menus.keys():
		var nodo_menu = dic_menus[clave]
		
		if (clave == "play"):
			nodo_menu.show()
		else:
			nodo_menu.hide()
		
	$NavBar.menu_requested.connect(_gestionar_cambio_de_menu)

func _gestionar_cambio_de_menu(nombre_menu: String):
	for clave in dic_menus.keys():
		var nodo_menu = dic_menus[clave]
		
		if (clave == nombre_menu):
			nodo_menu.show()
			cambiar_menu(nodo_menu)
		else:
			nodo_menu.hide()


func cambiar_menu(menu_nuevo: Control):
	# 1. Si hay un menú abierto, lo animamos para que se vaya
	if menu_actual != null and menu_actual != menu_nuevo:
		animar_salida(menu_actual)
	
	# 2. Preparamos el menú nuevo
	menu_nuevo.visible = true
	menu_nuevo.modulate.a = 0.0 # Empezamos invisible
	menu_nuevo.position.y = 20   # Empezamos un poco más abajo
	
	# 3. Animamos la entrada del nuevo
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menu_nuevo, "modulate:a", 1.0, 0.4)
	tween.tween_property(menu_nuevo, "position:y", 0, 0.4)
	
	menu_actual = menu_nuevo


func animar_salida(menu: Control):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(menu, "modulate:a", 0.0, 0.3)
	tween.tween_property(menu, "position:y", -20, 0.3) # Sube un poco al irse
	
	# Al terminar, lo ocultamos para que no estorbe
	tween.chain().tween_callback(menu.hide)
