extends RefCounted
class_name Stats

func _init(data: CharacterDataModel) -> void:
	fuerzaEmpuje = data.knokForce
	resistenciaEmpuje = data.knokResistance
	velocidad = data.speed
	pasiva = data.talent
	habilidad = data.ability

var equipo: String = ""

var fuerzaEmpuje: int = 0
var resistenciaEmpuje: int = 0
var velocidad: int = 0

var pasiva: String = ""
var habilidad: String = ""
