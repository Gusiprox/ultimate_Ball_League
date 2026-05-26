extends Control

const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.634, 0.634, 0.634, 1.0)

@onready var charactersPage = $marginMenu/Control/charactersPage
@onready var hatsPage = $marginMenu/Control/hatsPage
@onready var btnCharactersPage = $marginMenu/Control/contButtons/btnCharactersPage
@onready var btnHatsPage = $marginMenu/Control/contButtons/btnHatsPage

func _ready() -> void:
	actualizarBotones(btnCharactersPage, charactersPage)


# --- BOTONES ---

func _on_btn_characters_page_pressed() -> void:
	actualizarBotones(btnCharactersPage, charactersPage)

func _on_btn_hats_page_pressed() -> void:
	actualizarBotones(btnHatsPage, hatsPage)


# Cambiar el botón del menú actual

func actualizarBotones(botonActivo: Button, pagActiva: Control):
	btnCharactersPage.modulate = COLOR_INACTIVO
	btnHatsPage.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	charactersPage.visible = false
	hatsPage.visible = false
	pagActiva.visible = true
