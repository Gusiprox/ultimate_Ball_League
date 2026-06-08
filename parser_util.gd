extends Node


@onready var characterPlaceholder = preload("res://characters/CharacterPlaceholder.tscn")

func _charactersDataToCharactersBody(charactersData: Array[CharacterDataModel]) -> Array[CharacterBody3D]:
	
	var returnValue: Array[CharacterBody3D] = []
	
	for characterData: CharacterDataModel in charactersData:
		var newCharacter = characterPlaceholder.instantiate()
		
		newCharacter._setData(characterData)
		
		returnValue.push_front(newCharacter)

	return returnValue
