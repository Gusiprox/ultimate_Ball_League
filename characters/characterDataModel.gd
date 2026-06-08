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
const habilityDir = "hability"
const pasiveDir = "pasive"

var id: int

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

	name = data.get(nameDicDir)
	knokForce = data.get(kForceDicDir)
	knokResistance = data.get(kResistanceDicDir)
	speed = data.get(speedDicDir)
	skinBody = data.get(bodyDicDir)
	skinFoots = data.get(FootsDicDir)
	skinEyes = data.get(eyesDicDir)
	skinHat = data.get(hatDicDir)
	skinMouth = data.get(MouthDicDir)
	if data.get(habilityDir) != null:
		ability = data.get(habilityDir)
	if data.get(pasiveDir) != null:
		talent = data.get(pasiveDir)
