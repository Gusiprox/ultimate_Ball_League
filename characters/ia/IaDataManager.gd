extends Node

signal allPrepared

var iaTeam: Array[CharacterBody3D]

func _getIaTeam() -> Array[CharacterBody3D]:
	var dict = {
		"FunctionName": "getRandomTeam",
		"keys": [
			"BarKey"
		]
	}
	PlayFabManager.client.post_dict_auth(
		dict, 
		"/Client/ExecuteCloudScript", 
		PlayFab.AUTH_TYPE.SESSION_TICKET, 
		_setTeam
	)
	await allPrepared
	return iaTeam
	
func _setTeam(a):
	
	var charactersData: Dictionary = a.data.FunctionResult
	var charactersModelData: Array[CharacterDataModel] = []
	
	for characterData in charactersData:
		var charcterDataModel = CharacterDataModel.new(charactersData.get(characterData))
		
		charactersModelData.push_front(charcterDataModel)
	iaTeam = ParserUtil._charactersDataToCharactersBody(charactersModelData)
	allPrepared.emit()
