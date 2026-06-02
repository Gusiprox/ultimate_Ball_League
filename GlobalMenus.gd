# res://menus/GlobalMenus.gd
extends Node

const MENU_ESC = "menuEsc"
const METODO_GESTIONAR_ESC = "gestionarEscPulsado"
# El tiempo estándar para todo el juego si no se especifica otra cosa
const TIEMPO_ESTANDAR : float = 0.2
const DISTANCIA_ESTANDAR: int = 20
const OPACIDAD_ESTANDAR: float = 1.0

# Anima la entrada de un menú controlando tiempo, distancia de desplazamiento y opacidad máxima.
func animarEntrada(
	nodo: Control, 
	posicionOriginal: Vector2, 
	esGlobal: bool = false, 
	tiempo: float = TIEMPO_ESTANDAR, 
	distancia: int = DISTANCIA_ESTANDAR, 
	opacidadMaxima: float = OPACIDAD_ESTANDAR
) -> Tween:
	
	nodo.modulate.a = 0.0
	nodo.show()
	
	# Aplicamos el desplazamiento dinámico
	if esGlobal:
		nodo.global_position.y = posicionOriginal.y + distancia
	else:
		nodo.position.y = posicionOriginal.y + distancia
		
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animamos la opacidad hacia el valor objetivo
	tween.tween_property(nodo, "modulate:a", opacidadMaxima, tiempo)
	
	# Animamos la posición de vuelta a su origen
	if esGlobal:
		tween.tween_property(nodo, "global_position:y", posicionOriginal.y, tiempo)
	else:
		tween.tween_property(nodo, "position:y", posicionOriginal.y, tiempo)
	
	return tween

# Resetea un menú a su estado oculto e inicial
func resetearSalidaMenu(nodo: Control, posicionOriginal: Vector2, esGlobal: bool = false) -> void:
	nodo.hide()
	if esGlobal:
		nodo.global_position = posicionOriginal
	else:
		nodo.position = posicionOriginal

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(MENU_ESC):
		var escenaActual = get_tree().current_scene
		
		if escenaActual.has_method(METODO_GESTIONAR_ESC):
			escenaActual.gestionarEscPulsado()
