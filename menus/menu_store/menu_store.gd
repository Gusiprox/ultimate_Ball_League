extends Control

@onready var itemCardNode = preload("res://menus/cards/items/item_icon.tscn")
@onready var scrollShopItems = $marginMenuStore/frame/contStoreElem/marginStore/contScroll

var items: Array[ItemData] = []

func _ready() -> void:
	for itemData in PlayerData.shopItems:
		items.push_front(itemData)
	_setShopItems()
	
func _setShopItems():
	items.clear()
	
	for item in items:
		var newCard = itemCardNode.instantiate()
		
		newCard._setData(item)
		
		scrollShopItems.add_child(newCard)
