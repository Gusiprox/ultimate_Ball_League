extends Panel

@export var busName: String = "Musica"
var busIndex: int

func _ready() -> void:
	busIndex = AudioServer.get_bus_index(busName)

func _on_adjust_music_value_changed(newValue: float):
	# Convertimos el 0.0 - 1.0 del slider a decibelios
	var dbValue = linear_to_db(newValue)
	
	# Aplicamos el volumen al bus
	AudioServer.set_bus_volume_db(busIndex, dbValue)
	
	# Si el valor es 0, muteamos el bus para ahorrar procesos
	AudioServer.set_bus_mute(busIndex, newValue == 0)
