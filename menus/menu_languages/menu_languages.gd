extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_btn_es_pressed() -> void:
	TranslationServer.set_locale("es")


func _on_btn_en_pressed() -> void:
	TranslationServer.set_locale("en")
