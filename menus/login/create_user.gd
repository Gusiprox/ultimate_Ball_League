extends Control

const USERNAME_LENGTH: int = 3
const PASSWORD_LENGTH: int = 6
const ARROBA: String = "@"

@onready var email = $contCreateUserElem/email
@onready var password = $contCreateUserElem/password
@onready var username = $contCreateUserElem/username
@onready var contError = $contCreateUserElem/contError
@onready var contCorrect = $contCreateUserElem/contCorrect

var pathMenuAll = "res://menus/menu_all/menu_all.tscn"

func _ready() -> void:
	contError.hide()
	contCorrect.hide()
	PlayFabManager.client.registered.connect(_onSuccessfull)
	PlayFabManager.client.api_error.connect(_onError)

func _onButtonDown() -> void:
	contCorrect.hide()
	var emailText: String = email.text
	var passwordText: String = password.text
	var usernameText: String = username.text
	
	if usernameText.length() < USERNAME_LENGTH:
		contError.show()
		return 
		
	if passwordText.length() < PASSWORD_LENGTH:
		contError.show()
		return
		
	if emailText.is_empty() or not ARROBA in emailText:
		contError.show()
		return
		
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
	contError.hide()
	contCorrect.show()
	pass
	# Crear aqui algo para salir del menu de crear usuario y decir que ha salido bien
	
func _onError(result) -> void:
	contError.show()
	print("Fallo") # Aqui los fallos
