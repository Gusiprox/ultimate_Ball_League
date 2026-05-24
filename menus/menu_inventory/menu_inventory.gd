extends Control

@onready var charactersPage = $marginMenu/Control/charactersPage
@onready var hatsPage = $marginMenu/Control/hatsPage
@onready var btnCharactersPage = $marginMenu/Control/contButtons/btnCharactersPage
@onready var btnHatsPage = $marginMenu/Control/contButtons/btnHatsPage

var colorActivo = Color(1, 1, 1, 1)
var colorInactivo = Color(0.634, 0.634, 0.634, 1.0)

func _ready() -> void:
	actualizarBotones(btnCharactersPage, charactersPage)


# --- BOTONES ---

func _on_btn_characters_page_pressed() -> void:
	actualizarBotones(btnCharactersPage, charactersPage)

func _on_btn_hats_page_pressed() -> void:
	actualizarBotones(btnHatsPage, hatsPage)



func actualizarBotones(botonActivo: Button, pagActiva: Control):
	btnCharactersPage.modulate = colorInactivo
	btnHatsPage.modulate = colorInactivo
	
	botonActivo.modulate = colorActivo
	charactersPage.visible = false
	hatsPage.visible = false
	pagActiva.visible = true
