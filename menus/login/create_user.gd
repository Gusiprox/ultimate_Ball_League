extends Control

@onready var email = $TextEdit
@onready var password = $TextEdit2
@onready var username = $TextEdit3


func _onButtonDown() -> void:
	var emailText = email.text
	var passwordText = password.text
	var usernameText = username.text
	
	PlayFabManager.client.register_email_password(
		usernameText,
		emailText,
		passwordText,
		null
	)
