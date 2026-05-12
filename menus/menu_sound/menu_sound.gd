extends Panel

@export var bus_name: String = "Musica"
var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_adjust_music_value_changed(new_value: float):
	# Convertimos el 0.0 - 1.0 del slider a decibelios
	var db_value = linear_to_db(new_value)
	
	# Aplicamos el volumen al bus
	AudioServer.set_bus_volume_db(bus_index, db_value)
	
	# Si el valor es 0, muteamos el bus para ahorrar procesos
	AudioServer.set_bus_mute(bus_index, new_value == 0)
