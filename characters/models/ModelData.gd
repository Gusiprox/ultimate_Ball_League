extends RefCounted
class_name ModelData

func _init(data: CharacterDataModel) -> void:
	
	if data == null:
		return
	skinBody = data.skinBody
	skinFoots = data.skinFoots
	skinEyes = data.skinEyes
	skinHat = data.skinHat
	skinMouth = data.skinMouth

var skinBody: String
var skinFoots: String
var skinEyes: String
var skinHat: String
var skinMouth: String
