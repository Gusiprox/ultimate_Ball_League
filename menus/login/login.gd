extends Control

var pathMenuAll = "res://menus/menu_all/menu_all.tscn"
@onready var email = $VBoxContainer/TextBoxEmail
@onready var password = $VBoxContainer/TextBoxPassword

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayFabManager.client.logged_in.connect(_on_playfab_logged_in)
	PlayFabManager.client.api_error.connect(_on_login_error)
	
func _onButtonDown() -> void:
	
	var emailString = email.text
	var passwordString = password.text
	var dictionary: Dictionary = {}
	var info_params = GetPlayerCombinedInfoRequestParams.new()
	
	info_params.GetUserVirtualCurrency = true
	info_params.GetPlayerProfile = true
	
	PlayFabManager.client.login_with_email(
		emailString,
		passwordString,
		dictionary,
		info_params
	)
	
func _on_playfab_logged_in(data: LoginResult) -> void:
	email.text = ""
	password.text = ""
	PlayerData._setData(data)
	get_tree().change_scene_to_file(pathMenuAll)

func _on_login_error(data) -> void:
	push_warning(data)
