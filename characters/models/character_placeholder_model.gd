extends Node3D

@onready var boca = $Armature_001/Skeleton3D/boca
@onready var ojos = $Armature_001/Skeleton3D/Ojos
@onready var pies = $Armature_001/Skeleton3D/botas
@onready var cuerpo = $Armature_001/Skeleton3D/cuerpo
@onready var gorra = $Armature_001/Skeleton3D/gorra

func _setData(data: ModelData):
	boca.mesh = ModelsManager._getMeshById(data.skinMouth, ModelsManager.Parte.BOCA)
	ojos.mesh = ModelsManager._getMeshById(data.skinEyes, ModelsManager.Parte.OJO)
	pies.mesh = ModelsManager._getMeshById(data.skinFoots, ModelsManager.Parte.PIE)
	cuerpo.mesh = ModelsManager._getMeshById(data.skinBody, ModelsManager.Parte.CUERPO)
	gorra.mesh = ModelsManager._getMeshById(data.skinHat, ModelsManager.Parte.GORRA)
