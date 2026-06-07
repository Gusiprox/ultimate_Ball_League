extends SubViewportContainer

@onready var modelplace = $SubViewport/CharacterPlaceholder

func _setData(data: ModelData):
	modelplace._setData(data)
