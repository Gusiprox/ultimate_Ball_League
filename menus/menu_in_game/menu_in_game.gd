extends Control

const GUARDAR_POSICIONES_REALES = "guardarPosicionesReales"
const TIEMPO_ANIMACION: float = 0.15
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0
const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.577, 0.577, 0.577, 1.0)

@onready var panelMenuInGame = $panelMenuInGame
@onready var backgroundBlur = $backgroundBlur
@onready var menuOptions = $MenuOptions
@onready var menuExit = $MenuExit

var posicionesSubmenus = {}
var submenusOptions: Array = []
var botonesMenuOptions: Array = []
var menus: Array = []

func _ready() -> void:
	
	menus = [panelMenuInGame, menuExit, menuOptions]
	
	menuOptions.cerradoSolicitado.connect(onMenuOptionsCerradoSolicitado)

	abrirMenuInGame()
	call_deferred(GUARDAR_POSICIONES_REALES)


func abrirMenuInGame():
	backgroundBlur.show()
	panelMenuInGame.show()

func onMenuOptionsCerradoSolicitado() -> void:
	animarSubmenu(panelMenuInGame)

func guardarPosicionesReales():
	for m in menus:
		posicionesSubmenus[m] = m.global_position
		if m != panelMenuInGame:
			m.hide()


# --- BOTONES ---

func _on_btn_resume_pressed() -> void:
	panelMenuInGame.hide()
	backgroundBlur.hide()

func _on_btn_options_pressed() -> void:
	animarSubmenu(menuOptions)

func _on_btn_exit_pressed() -> void:
	animarSubmenu(menuExit)

func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	animarSubmenu(panelMenuInGame)


#Animación de los submenús de MenuInGame

func animarSubmenu(menuObjetivo: Control):
	for m in [panelMenuInGame, menuExit, menuOptions]:
		if m != menuObjetivo and m.visible:
			GlobalMenus.resetearSalidaMenu(m, posicionesSubmenus[m], true)

	if menuObjetivo.visible:
		GlobalMenus.resetearSalidaMenu(menuObjetivo, posicionesSubmenus[menuObjetivo], true)
		backgroundBlur.hide()
		return

	backgroundBlur.show()

	GlobalMenus.animarEntrada(menuObjetivo, posicionesSubmenus[menuObjetivo], true, TIEMPO_ANIMACION, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION)


#Cambio de botón marcado en menuOptions

func actualizarBotonesOptions(botonActivo: Button, paginaActiva: Control):
	for boton in botonesMenuOptions:
		boton.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	
	for submenu in submenusOptions:
		submenu.hide()
	
	paginaActiva.show()
