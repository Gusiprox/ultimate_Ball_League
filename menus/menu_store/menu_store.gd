extends Control

var items: Array[ItemData] = []

func _ready() -> void:
	for itemData in PlayerData.shopItems:
		items.push_front(ItemData.new(itemData))
	
