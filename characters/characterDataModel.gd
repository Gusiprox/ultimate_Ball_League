extends RefCounted
class_name CharacterDataModel

const nameDicDir = "characterName"
const kForceDicDir = "knockForce"
const kResistanceDicDir = "knockResistance"
const speedDicDir = "speed"
const bodyDicDir = "modelBody"
const eyesDicDir = "modelEyes"
const MouthDicDir = "modelMouth"
const FootsDicDir = "modelFoots"
const hatDicDir = "modelHat"

var id

var name: String

var knokForce: int
var knokResistance: int
var speed: int

var ability: String
var talent: String

var skinBody: String
var skinFoots: String
var skinEyes: String
var skinHat: String
var skinMouth: String

func _init(data: Dictionary) -> void:
	var eatDataDir: Dictionary = data.data.FunctionResult
	
	name = eatDataDir.get(nameDicDir)
	knokForce = eatDataDir.get(kForceDicDir)
	knokResistance = eatDataDir.get(kResistanceDicDir)
	speed = eatDataDir.get(speedDicDir)
	skinBody = eatDataDir.get(bodyDicDir)
	skinFoots = eatDataDir.get(FootsDicDir)
	skinEyes = eatDataDir.get(eyesDicDir)
	skinHat = eatDataDir.get(hatDicDir)
	skinMouth = eatDataDir.get(MouthDicDir)
