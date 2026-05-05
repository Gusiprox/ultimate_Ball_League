extends CanvasLayer

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
		else:
			nodo_menu.hide()
