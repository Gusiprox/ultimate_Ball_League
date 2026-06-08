extends SubViewportContainer

@onready var modelHat = $SubViewport/MeshInstance3D

func _setData(data: ItemData):
	modelHat.mesh = ModelsManager._getMeshById(data.itemId, ModelsManager.Parte.GORRA)
