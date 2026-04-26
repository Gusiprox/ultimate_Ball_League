extends Panel

@onready var menuUser = $MenuUser



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuUser.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_btn_menu_user_pressed() -> void:
	if(menuUser.visible == true):
		menuUser.visible = false
	else:
		menuUser.visible = true
