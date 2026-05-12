extends Control

@onready var charactersPage = $marginMenu/Control/charactersPage
@onready var hatsPage = $marginMenu/Control/hatsPage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charactersPage.visible = true
	hatsPage.visible = false



func _on_btn_characters_page_pressed() -> void:
	charactersPage.visible = true
	hatsPage.visible = false


func _on_btn_hats_page_pressed() -> void:
	charactersPage.visible = false
	hatsPage.visible = true
