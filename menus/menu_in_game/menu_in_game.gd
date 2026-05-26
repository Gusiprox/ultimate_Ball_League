extends Control

const GUARDAR_POSICIONES_REALES = "guardarPosicionesReales"
const TIEMPO_ANIMACION : float = 0.15
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0
const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.577, 0.577, 0.577, 1.0)

@onready var panelMenuInGame = $panelMenuInGame
@onready var backgroundBlur = $backgroundBlur
@onready var menuOptions = $MenuOptions
@onready var menuControls = $MenuOptions/MenuControls
@onready var menuSound = $MenuOptions/MenuSound
@onready var btnSound = $MenuOptions/marginMenuOpt/contMenuOptBtn/btnSonido
@onready var btnControls = $MenuOptions/marginMenuOpt/contMenuOptBtn/btnControls
@onready var menuExit = $MenuExit

var posicionesSubmenus = {}

func _ready() -> void:
	backgroundBlur.visible = true
	menuSound.visible = true
	menuControls.visible = false
	call_deferred(GUARDAR_POSICIONES_REALES)

func guardarPosicionesReales():
	for m in [panelMenuInGame, menuExit, menuOptions]:
		posicionesSubmenus[m] = m.global_position
		if m != panelMenuInGame:
			m.hide()


# --- BOTONES ---

func _on_btn_resume_pressed() -> void:
	panelMenuInGame.visible = false
	backgroundBlur.visible = false

func _on_btn_options_pressed() -> void:
	animarSubmenu(menuOptions)

func _on_btn_exit_pressed() -> void:
	animarSubmenu(menuExit)

func _on_btn_conf_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_cancel_exit_pressed() -> void:
	animarSubmenu(panelMenuInGame)

func _on_btn_close_options_pressed() -> void:
	animarSubmenu(panelMenuInGame)

func _on_btn_sonido_pressed() -> void:
	actualizarBotonesOptions(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizarBotonesOptions(btnControls, menuControls)


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

	GlobalMenus.animar_entrada(menuObjetivo, posicionesSubmenus[menuObjetivo], true, TIEMPO_ANIMACION, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION)


#Cambio de botón marcado en menuOptions

func actualizarBotonesOptions(botonActivo: Button, paginaActiva: Control):
	btnSound.modulate = COLOR_INACTIVO
	btnControls.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true
