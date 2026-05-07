extends Control

@onready var menuLogin = $panelLogin
@onready var menuCreate = $panelCreateUser
@onready var backgroundBlur = $backgroundBlur

var menu_actual: Control = null
var posiciones_iniciales = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuLogin.visible = false
	menuCreate.visible = false
	backgroundBlur.hide()
	# Guardamos la posición central real de cada menú al iniciar
	posiciones_iniciales[$panelLogin] = $panelLogin.position
	posiciones_iniciales[$panelCreateUser] = $panelCreateUser.position


func _on_btn_create_user_pressed() -> void:
	menuLogin.visible = true
	menuCreate.visible = false
	backgroundBlur.visible = true
	cambiar_menu(menuLogin)
	#Gestionar que se hayan metido todos los datos
	#Falta que se cree de verdad la cuenta


func _on_btn_start_pressed() -> void:
	menuLogin.visible = true
	backgroundBlur.visible = menuLogin.visible
	cambiar_menu(menuLogin)


func _on_btn_close_login_pressed() -> void:
	menuLogin.visible = false
	if(menuLogin.visible == false && menuCreate.visible == false):
		backgroundBlur.visible = false


func _on_btn_close_create_user_pressed() -> void:
	menuCreate.visible = false
	if(menuLogin.visible == false && menuCreate.visible == false):
		backgroundBlur.visible = false


func _on_btn_login_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menu_all/menu_all.tscn")


func _on_btn_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_open_create_user_pressed() -> void:
	menuLogin.visible = false
	menuCreate.visible = true
	cambiar_menu(menuCreate)


func cambiar_menu(menu_nuevo: Control):
	if menu_actual != null and menu_actual != menu_nuevo:
		animar_salida(menu_actual)
	
	menu_nuevo.visible = true
	menu_nuevo.modulate.a = 0.0
	
	# RECUPERAMOS EL CENTRO REAL:
	var centro_real = posiciones_iniciales[menu_nuevo]
	
	# Lo colocamos un poco desplazado para que entre con movimiento
	menu_nuevo.position.y = centro_real.y + 30 
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Animamos exactamente hasta el centro_real guardado en _ready
	tween.tween_property(menu_nuevo, "modulate:a", 1.0, 0.4)
	tween.tween_property(menu_nuevo, "position:y", centro_real.y, 0.4)
	
	menu_actual = menu_nuevo


func animar_salida(menu: Control):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(menu, "modulate:a", 0.0, 0.3)
	tween.tween_property(menu, "position:y", -20, 0.3) # Sube un poco al irse
	
	# Al terminar, lo ocultamos para que no estorbe
	tween.chain().tween_callback(menu.hide)
