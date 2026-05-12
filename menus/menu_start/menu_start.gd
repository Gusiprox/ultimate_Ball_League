extends Control

@onready var menuLogin = $panelLogin
@onready var menuCreate = $panelCreateUser
@onready var backgroundBlur = $backgroundBlur

var menu_actual: Control = null
var transicionando: bool = false
var posiciones_iniciales = {}

func _ready() -> void:
	menuLogin.visible = false
	menuCreate.visible = false
	backgroundBlur.hide()
	
	# Guardamos el centro real
	posiciones_iniciales[menuLogin] = menuLogin.position
	posiciones_iniciales[menuCreate] = menuCreate.position


# --- BOTONES ---

func _on_btn_start_pressed() -> void:
	backgroundBlur.show()
	cambiar_menu(menuLogin)

func _on_btn_open_create_user_pressed() -> void:
	cambiar_menu(menuCreate)

func _on_btn_create_user_pressed() -> void:
	#Gestionar que se hayan metido todos los datos
	#Falta que se cree de verdad la cuenta
	cambiar_menu(menuLogin)

func _on_btn_close_login_pressed() -> void:
	cerrar_todo()

func _on_btn_close_create_user_pressed() -> void:
	cerrar_todo()

func _on_btn_login_pressed() -> void:
	#Gestionar que el usuario exista antes de cambiar de escena
	get_tree().change_scene_to_file("res://menus/menu_all/menu_all.tscn")

func _on_btn_exit_pressed() -> void:
	get_tree().quit()


# --- LÓGICA DE ANIMACIÓN ---

func cambiar_menu(menu_nuevo: Control):
	if transicionando or menu_actual == menu_nuevo:
		return
	
	transicionando = true
	
	# 1. SALIDA INSTANTÁNEA
	if menu_actual != null:
		menu_actual.hide()
		# Reset de posición para que no se acumulen los +20px
		menu_actual.position = posiciones_iniciales[menu_actual]
	
	# 2. PREPARAR ENTRADA
	var pos_final = posiciones_iniciales[menu_nuevo]
	menu_nuevo.modulate.a = 0.0
	menu_nuevo.position.y = pos_final.y + 20 # Viene desde abajo
	menu_nuevo.show()
	
	# 3. ANIMACIÓN
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menu_nuevo, "modulate:a", 1.0, 0.2)
	tween.tween_property(menu_nuevo, "position:y", pos_final.y, 0.2)
	
	tween.set_parallel(false)
	tween.tween_callback(func():
		menu_actual = menu_nuevo
		transicionando = false
	)

func cerrar_todo():
	if menu_actual:
		menu_actual.hide()
		menu_actual.position = posiciones_iniciales[menu_actual]
	
	menu_actual = null
	backgroundBlur.hide()
	transicionando = false
