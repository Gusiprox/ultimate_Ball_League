extends ScrollContainer

@export var columns: int = 4
@export var modoActual: ModoCarta = ModoCarta.SIN_BTN
@onready var contBox = $GridContainer
const  cardMolde = preload("res://menus/cards/items/item_shop_card.tscn")

enum ModoCarta { SIN_BTN, BUY, EQUIP }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setData(PlayerData.shopItems)
	contBox.columns = columns
	EventBus.buyItem.connect(_buyItem)

func _setData(data: Array[ItemData]):
	_limpiarLista()
	for characterData: ItemData in data:
		var nuevaCarta = cardMolde.instantiate()
		aplicarModoCarta(nuevaCarta)
		nuevaCarta._setData(characterData)
		
		contBox.add_child(nuevaCarta)

func _limpiarLista():
	for child in contBox.get_children():
		child.queue_free()

func aplicarModoCarta(nuevaCarta: Node):
	match modoActual:
		ModoCarta.SIN_BTN:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.SIN_BTN
		ModoCarta.BUY:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.BUY
		ModoCarta.EQUIP:
			nuevaCarta.modoActual = nuevaCarta.ModoCarta.EQUIP

func _buyItem(itemData: ItemData):
	var dict = {
		"ItemId": itemData.itemId,       # El ID exacto del artículo en tu catálogo (String)
		"VirtualCurrency": "GO",           # Las iniciales de tu moneda Legacy, ej: "CO" o "GR" (String)
		"Price": 500,                      # El precio EXACTO que configuraste en el panel (Int)
		"CatalogVersion": "hats"           # El nombre de tu catálogo, por defecto "Main" (String)
	}
	PlayFabManager.client.post_dict_auth(
		dict, 
		"/Client/PurchaseItem", 
		PlayFab.AUTH_TYPE.SESSION_TICKET, 
		_suscessfullPurchase
	)

func _suscessfullPurchase(a):
	pass
