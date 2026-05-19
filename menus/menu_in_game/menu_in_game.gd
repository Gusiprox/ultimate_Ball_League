extends Control

@onready var panelMenuInGame = $panelMenuInGame
@onready var backgroundBlur = $backgroundBlur
@onready var menuOptions = $MenuOptions
@onready var menuControls = $MenuOptions/MenuControls
@onready var menuSound = $MenuOptions/MenuSound
@onready var btnSound = $MenuOptions/marginMenuOpt/contMenuOptBtn/btnSonido
@onready var btnControls = $MenuOptions/marginMenuOpt/contMenuOptBtn/btnControls
@onready var menuExit = $MenuExit

var posicionesSubmenus = {}
var colorActivo = Color(1, 1, 1, 1)
var colorInactivo = Color(0.577, 0.577, 0.577, 1.0)

func _ready() -> void:
	backgroundBlur.visible = true
	menuSound.visible = true
	menuControls.visible = false
	call_deferred("guardarPosicionesReales")

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
			m.hide()
			m.position = posicionesSubmenus[m]

	if menuObjetivo.visible:
		menuObjetivo.hide()
		menuObjetivo.position = posicionesSubmenus[menuObjetivo]
		backgroundBlur.hide()
		return

	var posFinal = posicionesSubmenus[menuObjetivo]
	menuObjetivo.modulate.a = 0.0
	# Aplicamos el desplazamiento a la posición GLOBAL
	menuObjetivo.global_position.y = posFinal.y + 20 
	menuObjetivo.show()
	backgroundBlur.show()

	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(menuObjetivo, "modulate:a", 1.0, 0.15)
	tween.tween_property(menuObjetivo, "global_position:y", posFinal.y, 0.15)


#Cambio de botón marcado en menuOptions

func actualizarBotonesOptions(botonActivo: Button, paginaActiva: Control):
	btnSound.modulate = colorInactivo
	btnControls.modulate = colorInactivo
	
	botonActivo.modulate = colorActivo
	menuSound.visible = false
	menuControls.visible = false
	paginaActiva.visible = true
