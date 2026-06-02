extends Control

const COLOR_ACTIVO = Color(1, 1, 1, 1)
const COLOR_INACTIVO = Color(0.634, 0.634, 0.634, 1.0)

@onready var charactersPage = $marginMenuInventory/charactersPage
@onready var hatsPage = $marginMenuInventory/hatsPage
@onready var btnCharactersPage = $marginMenuInventory/contButtons/btnCharactersPage
@onready var btnHatsPage = $marginMenuInventory/contButtons/btnHatsPage

var botonesInventario: Array = []
var pagesInventario: Array = []

func _ready() -> void:
	
	botonesInventario = [btnCharactersPage, btnHatsPage]
	pagesInventario = [charactersPage, hatsPage]
	
	charactersPage.show()
	actualizarBotones(btnCharactersPage, charactersPage)


# --- BOTONES ---

func _on_btn_characters_page_pressed() -> void:
	actualizarBotones(btnCharactersPage, charactersPage)

func _on_btn_hats_page_pressed() -> void:
	actualizarBotones(btnHatsPage, hatsPage)


# Cambiar el botón del menú actual

func actualizarBotones(botonActivo: Button, pagActiva: Control):
	for boton in botonesInventario:
		boton.modulate = COLOR_INACTIVO
	
	botonActivo.modulate = COLOR_ACTIVO
	
	for page in pagesInventario:
		page.hide()
	
	pagActiva.visible = true
