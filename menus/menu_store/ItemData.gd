extends RefCounted
class_name ItemData

const itemIdDic: String = "ItemId"
const nameDic: String = "DisplayName"

var itemId: String
var name: String

func _init(data: Dictionary) -> void:
	itemId = data.get(itemIdDic)
	name = data.get(nameDic)
