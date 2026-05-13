extends Control

@onready var charactersPage = $marginMenu/Control/charactersPage
@onready var hatsPage = $marginMenu/Control/hatsPage
@onready var btnCharactersPage = $marginMenu/Control/contButtons/btnCharactersPage
@onready var btnHatsPage = $marginMenu/Control/contButtons/btnHatsPage


var color_activo = Color(1, 1, 1, 1)
var color_inactivo = Color(0.634, 0.634, 0.634, 1.0)

func _ready() -> void:
	charactersPage.visible = true
	hatsPage.visible = false

func _on_btn_characters_page_pressed() -> void:
	actualizar_botones(btnCharactersPage)
	charactersPage.visible = true
	hatsPage.visible = false

func _on_btn_hats_page_pressed() -> void:
	actualizar_botones(btnHatsPage)
	charactersPage.visible = false
	hatsPage.visible = true

func actualizar_botones(boton_activo: Button):
	btnCharactersPage.modulate = color_inactivo
	btnHatsPage.modulate = color_inactivo
	
	btnCharactersPage.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btnHatsPage.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	boton_activo.modulate = color_activo
	boton_activo.mouse_default_cursor_shape = Control.CURSOR_ARROW
