extends Control

const PATH_MENU_ALL = "res://menus/menu_all/menu_all.tscn"
const TIEMPO_ANIMACION : float = 0.2
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0

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
	cambiarMenu(menuLogin)

func _on_btn_open_create_user_pressed() -> void:
	cambiarMenu(menuCreate)

func _on_btn_create_user_pressed() -> void:
	#Gestionar que se hayan metido todos los datos
	#Falta que se cree de verdad la cuenta
	cambiarMenu(menuLogin)

func _on_btn_close_login_pressed() -> void:
	cerrarTodo()

func _on_btn_close_create_user_pressed() -> void:
	cerrarTodo()

func _on_btn_login_pressed() -> void:
	#Gestionar que el usuario exista antes de cambiar de escena
	get_tree().change_scene_to_file(PATH_MENU_ALL)

func _on_btn_exit_pressed() -> void:
	get_tree().quit()


# --- LÓGICA DE ANIMACIÓN ---

func cambiarMenu(menuNuevo: Control):
	if transicionando or menuActual == menuNuevo:
		return
	
	transicionando = true
	
	if menuActual != null:
		GlobalMenus.resetearSalidaMenu(menuActual, posicionesIniciales[menuActual])
	
	await GlobalMenus.animarEntrada(menuNuevo, posicionesIniciales[menuNuevo], false, TIEMPO_ANIMACION, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION).finished
	
	menuActual = menuNuevo
	transicionando = false


#Cerrar los menús login y create user

func cerrarTodo():
	if menuActual:
		GlobalMenus.resetearSalidaMenu(menuActual, posicionesIniciales[menuActual])
	
	menuActual = null
	backgroundBlur.hide()
	transicionando = false
