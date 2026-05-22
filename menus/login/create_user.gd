extends Control

@onready var email = $email
@onready var password = $password
@onready var username = $username


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

func _onSuccessfull(result) -> void:
	print("Correcto")
	
func _onError(result) -> void:
	print("Fallo")
