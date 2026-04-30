extends CanvasLayer

@onready var menuPlay = $MenuPlay
@onready var menuEditarPers = $MenuEditCharacter
@onready var menuStore = $MenuStore

@onready var dic_menus = {
	"play": $MenuPlay,
	"editCharacter": $MenuEditCharacter,
	"editTeam": $MenuEditTeam,
	"gacha": $MenuGacha,
	"store": $MenuStore
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuEditarPers.visible = false
	$NavBar.menu_requested.connect(_gestionar_cambio_de_menu)

func _gestionar_cambio_de_menu(nombre_menu: String):
	for clave in dic_menus.keys():
		var nodo_menu = dic_menus[clave]
		
		if (clave == nombre_menu):
			nodo_menu.show()
		else:
			nodo_menu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
