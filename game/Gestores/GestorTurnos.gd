class_name GestorTurnos

signal turnoCambiado(personaje: CharacterBody3D)
signal turnoFinalizado(personaje: CharacterBody3D)

var valorAccionUsado: float
var turnoActual: Dictionary
var cola: Array[Dictionary] = []

func iniciar(personajes: Array[CharacterBody3D]) -> void:
	cola.clear()

	for p: CharacterBody3D in personajes:
		cola.append({Constantes.DICTIONARY_KEY_PERSONAJE: p, Constantes.DICTIONARY_KEY_VALOR_ACCION: Constantes.VALOR_UNIVERSAL_TURNO / float(p.stats.velocidad)})

	_ordenarCola()
	call_deferred("_notificarTurnoActual")

func _notificarTurnoActual() -> void:
	turnoCambiado.emit(getPersonajeActual())

func getPersonajeActual() -> CharacterBody3D:
	return cola[0][Constantes.DICTIONARY_KEY_PERSONAJE] if not cola.is_empty() else null

func terminarTurno() -> void:
	if cola.is_empty():
		return

	turnoFinalizado.emit(getPersonajeActual())

	turnoActual = cola.pop_front()
	valorAccionUsado = turnoActual[Constantes.DICTIONARY_KEY_VALOR_ACCION]

	for personajeEnCola: Dictionary in cola:
		personajeEnCola[Constantes.DICTIONARY_KEY_VALOR_ACCION] -= valorAccionUsado

	turnoActual[Constantes.DICTIONARY_KEY_VALOR_ACCION] = Constantes.VALOR_UNIVERSAL_TURNO / float(turnoActual[Constantes.DICTIONARY_KEY_PERSONAJE].stats.velocidad)
	cola.append(turnoActual)

	_ordenarCola()
	turnoCambiado.emit(getPersonajeActual())

func _ordenarCola() -> void:
	cola.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a[Constantes.DICTIONARY_KEY_VALOR_ACCION] < b[Constantes.DICTIONARY_KEY_VALOR_ACCION]
	)
