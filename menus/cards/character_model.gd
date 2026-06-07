extends SubViewportContainer

@onready var model = $SubViewport/CharacterPlaceholder

func _setData(data: ModelData):
	model._setData(data)
