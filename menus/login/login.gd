extends Control

const EYE_ICON_PATH = "res://menus/login/img/eye.png"
const EYE_SLASH_ICON_PATH = "res://menus/login/img/eyeSlash.png"

var pathMenuAll = "res://menus/menu_all/menu_all.tscn"
@onready var email = $VBoxContainer/TextBoxEmail
@onready var password = $VBoxContainer/TextBoxPassword
@onready var contError = $VBoxContainer/contError
@onready var btnSeePassword = $VBoxContainer/TextBoxPassword/btnSeePassword
@onready var btnLogin = $VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contError.hide()
	btnSeePassword.icon = load(EYE_SLASH_ICON_PATH)
	PlayFabManager.client.logged_in.connect(_on_playfab_logged_in)
	PlayFabManager.client.api_error.connect(_on_login_error)

func _on_btn_see_password_pressed() -> void:
	password.secret = not password.secret
	
	if password.secret:
		btnSeePassword.icon = load(EYE_SLASH_ICON_PATH)
	else:
		btnSeePassword.icon = load(EYE_ICON_PATH)


func _onButtonDown() -> void:
	
	btnLogin.disabled = true
	
	var emailString = email.text
	var passwordString = password.text
	var dictionary: Dictionary = {}
	var info_params = GetPlayerCombinedInfoRequestParams.new()
	
	info_params.GetUserVirtualCurrency = true
	info_params.GetPlayerProfile = true
	info_params.GetUserReadOnlyData = true
	info_params.GetUserInventory = true
	
	PlayFabManager.client.login_with_email(
		emailString,
		passwordString,
		dictionary,
		info_params
	)

func _on_playfab_logged_in(data: LoginResult) -> void:
	email.text = ""
	password.text = ""
	await PlayerData._setData(data)
	get_tree().change_scene_to_file(pathMenuAll)

func _on_login_error(data) -> void:
	if contError.visible:
		contError.hide()
		await get_tree().create_timer(0.07).timeout
		contError.show()
	else:
		contError.show()
	
	btnLogin.disabled = false
	
	push_warning(data)
