class_name GestorTurnos

signal turnoCambiado(personaje: CharacterBody3D)

var cola: Array[Dictionary] = []

func iniciar(personajes: Array[CharacterBody3D]) -> void:
	cola.clear()

	for p: CharacterBody3D in personajes:
		cola.append({
			"personaje": p,
			"valorAccion": Constantes.VALOR_UNIVERSAL_TURNO / float(p.stats.velocidad)
		})

	_ordenarCola()
	call_deferred("_notificarTurnoActual")

func _notificarTurnoActual() -> void:
	turnoCambiado.emit(getPersonajeActual())

func getPersonajeActual() -> CharacterBody3D:
	return cola[0].personaje if not cola.is_empty() else null

func terminarTurno() -> void:
	if cola.is_empty():
		return

	var turnoActual: Dictionary = cola.pop_front()
	var valorAccionUsado: float = turnoActual.valorAccion

	for personajeEnCola: Dictionary in cola:
		personajeEnCola.valorAccion -= valorAccionUsado

	turnoActual.valorAccion = Constantes.VALOR_UNIVERSAL_TURNO / float(turnoActual.personaje.stats.velocidad)
	cola.append(turnoActual)

	_ordenarCola()
	turnoCambiado.emit(getPersonajeActual())

func _ordenarCola() -> void:
	cola.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.valorAccion < b.valorAccion
	)
