extends Panel

@onready var menuUser = $MenuUser
@onready var menuExit = $MenuExit



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuUser.visible = false
	menuExit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_menu_user_pressed() -> void:
	menuUser.visible = !menuUser.visible


func _on_btn_exit_pressed() -> void:
	menuExit.visible = true


func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_cancel_exit_pressed() -> void:
	menuExit.visible = false
