extends Control

@onready var charactersPage = $marginMenu/Control/charactersPage
@onready var hatsPage = $marginMenu/Control/hatsPage
@onready var btnCharactersPage = $marginMenu/Control/contButtons/btnCharactersPage
@onready var btnHatsPage = $marginMenu/Control/contButtons/btnHatsPage


var colorActivo = Color(1, 1, 1, 1)
var colorInactivo = Color(0.634, 0.634, 0.634, 1.0)

func _ready() -> void:
	actualizar_botones(btnCharactersPage, charactersPage)

func _on_btn_characters_page_pressed() -> void:
	actualizar_botones(btnCharactersPage, charactersPage)

func _on_btn_hats_page_pressed() -> void:
	actualizar_botones(btnHatsPage, hatsPage)

func actualizar_botones(botonActivo: Button, pagActiva: Control):
	btnCharactersPage.modulate = colorInactivo
	btnHatsPage.modulate = colorInactivo
	
	botonActivo.modulate = colorActivo
	charactersPage.visible = false
	hatsPage.visible = false
	pagActiva.visible = true
