extends Control

@onready var email = $email
@onready var password = $password
@onready var username = $username

var pathMenuAll = "res://menus/menu_all/menu_all.tscn"

func _ready() -> void:
	PlayFabManager.client.registered.connect(_onSuccessfull)
	PlayFabManager.client.api_error.connect(_onError)

func _onButtonDown() -> void:
	var emailText: String = email.text
	var passwordText: String = password.text
	var usernameText: String = username.text
	var info_params = GetPlayerCombinedInfoRequestParams.new()
	
	info_params.GetUserVirtualCurrency = true
	info_params.GetPlayerProfile = true
	info_params.GetUserReadOnlyData = true
	info_params.GetUserInventory = true
	PlayFabManager.client.register_email_password(
		usernameText,
		emailText,
		passwordText,
		info_params
	)

func _onSuccessfull(data) -> void:
	pass
	# Crear aqui algo para salir del menu de crear usuario y decir que ha salido bien
	
func _onError(result) -> void:
	print("Fallo") # Aqui los fallos
