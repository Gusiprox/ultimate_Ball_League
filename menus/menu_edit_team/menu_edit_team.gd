extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dict = {
		"FunctionName": "getGacharters",
		"keys": [
			"BarKey"
		]
	}
	
	PlayFabManager.client.post_dict_auth(dict, "/Client/ExecuteCloudScript", PlayFab.AUTH_TYPE.SESSION_TICKET, _correct)


func _correct(a):
	a
