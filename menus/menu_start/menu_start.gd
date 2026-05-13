extends Control

@onready var menuLogin = $panelLogin
@onready var menuCreate = $panelCreateUser
@onready var backgroundBlur = $backgroundBlur

var menuActual: Control = null
var transicionando: bool = false
var posicionesIniciales = {}

func _ready() -> void:
	menuLogin.visible = false
	menuCreate.visible = false
	backgroundBlur.hide()
	
	# Guardamos el centro real
	posicionesIniciales[menuLogin] = menuLogin.position
	posicionesIniciales[menuCreate] = menuCreate.position


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

func cambiar_menu(menuNuevo: Control):
	if transicionando or menuActual == menuNuevo:
		return
	
	transicionando = true
	
	# 1. SALIDA INSTANTÁNEA
	if menuActual != null:
		menuActual.hide()
		# Reset de posición para que no se acumulen los +20px
		menuActual.position = posicionesIniciales[menuActual]
	
	# 2. PREPARAR ENTRADA
	var posFinal = posicionesIniciales[menuNuevo]
	menuNuevo.modulate.a = 0.0
	menuNuevo.position.y = posFinal.y + 20 # Viene desde abajo
	menuNuevo.show()
	
	# 3. ANIMACIÓN
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menuNuevo, "modulate:a", 1.0, 0.2)
	tween.tween_property(menuNuevo, "position:y", posFinal.y, 0.2)
	
	tween.set_parallel(false)
	tween.tween_callback(func():
		menuActual = menuNuevo
		transicionando = false
	)

func cerrar_todo():
	if menuActual:
		menuActual.hide()
		menuActual.position = posicionesIniciales[menuActual]
	
	menuActual = null
	backgroundBlur.hide()
	transicionando = false
