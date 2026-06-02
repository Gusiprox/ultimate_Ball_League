extends Panel

# Definimos una señal para avisar a la navbar de que queremos cerrar
signal cerradoSolicitado

const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.577, 0.577, 0.577, 1.0)

@onready var menuSound = $MenuSound
@onready var menuControls = $MenuControls
@onready var menuLanguages = $MenuLanguages
@onready var btnSound = $marginMenuOpt/contMenuOptBtn/btnSonido
@onready var btnControls = $marginMenuOpt/contMenuOptBtn/btnControls
@onready var btnLanguages = $marginMenuOpt/contMenuOptBtn/btnLanguages

var botonesMenuOptions: Array = []
var submenusOptions: Array = []

func _ready() -> void:
	botonesMenuOptions = [btnSound, btnControls, btnLanguages]
	submenusOptions = [menuSound, menuControls, menuLanguages]
	
	actualizarBotonesOptions(btnSound, menuSound)


# --- BOTONES ---

func _on_btn_sonido_pressed() -> void:
	actualizarBotonesOptions(btnSound, menuSound)

func _on_btn_controls_pressed() -> void:
	actualizarBotonesOptions(btnControls, menuControls)

func _on_btn_languages_pressed() -> void:
	actualizarBotonesOptions(btnLanguages, menuLanguages)

func _on_btn_close_options_pressed() -> void:
	cerradoSolicitado.emit()


func actualizarBotonesOptions(botonActivo: Button, paginaActiva: Control):
	for boton in botonesMenuOptions:
		boton.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	
	for menu in submenusOptions:
		menu.hide()
	
	paginaActiva.show()
