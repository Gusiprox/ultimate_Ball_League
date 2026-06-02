extends Control

const TIEMPO_ANIMACION : float = 0.15
const DISTANCIA_ANIMACION: int = 20
const OPACIDAD_ANIMACION: float = 1.0

@onready var menuListChar = $MenuListChar

var posicionesIniciales = {}

func _ready() -> void:
	menuListChar.hide()
	posicionesIniciales = menuListChar.global_position


# --- BOTONES ---

func _on_btn_change_char_pressed() -> void:
	GlobalMenus.animarEntrada(menuListChar, posicionesIniciales, false, TIEMPO_ANIMACION, DISTANCIA_ANIMACION, OPACIDAD_ANIMACION)

func _on_btn_close_menu_pressed() -> void:
	GlobalMenus.resetearSalidaMenu(menuListChar, posicionesIniciales)
