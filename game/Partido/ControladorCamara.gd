extends Node3D

var rotacionHorizontal: float = 0.0
var rotacionVertical: float = 0.0
var distanciaActual: float = Constantes.DISTANCIA_INICIAL_CAMARA
var arrastrandoRaton: bool = false

@onready var camara: Camera3D = $Camera3D

func _ready() -> void:
	_centrarMapa()
	_inicializarDesdeCamara()
	_actualizarPosicionCamara()

func _input(evento: InputEvent) -> void:
	if evento is InputEventMouseButton:
		_procesarEntradaRaton(evento)
	elif evento is InputEventMouseMotion and arrastrandoRaton:
		_procesarMovimientoRaton(evento)

func _centrarMapa() -> void:
	var centroX: float = (Constantes.ANCHO_MAPA - 1) * Constantes.TAMANO_CASILLA / 2.0
	var centroZ: float = (Constantes.LARGO_MAPA - 1) * Constantes.TAMANO_CASILLA / 2.0
	global_position = Vector3(centroX, 0.0, centroZ)

func _procesarEntradaRaton(evento: InputEventMouseButton) -> void:
	match evento.button_index:
		MOUSE_BUTTON_RIGHT:
			arrastrandoRaton = evento.pressed
		MOUSE_BUTTON_WHEEL_UP:
			if evento.pressed:
				_ajustarZoom(-Constantes.VELOCIDAD_ZOOM_CAMARA)
		MOUSE_BUTTON_WHEEL_DOWN:
			if evento.pressed:
				_ajustarZoom(Constantes.VELOCIDAD_ZOOM_CAMARA)

func _procesarMovimientoRaton(evento: InputEventMouseMotion) -> void:
	rotacionHorizontal -= evento.relative.x * Constantes.SENSIBILIDAD_CAMARA
	rotacionVertical += evento.relative.y * Constantes.SENSIBILIDAD_CAMARA
	rotacionVertical = clamp(rotacionVertical, Constantes.ANGULO_VERTICAL_MINIMO_CAMARA, Constantes.ANGULO_VERTICAL_MAXIMO_CAMARA)
	_actualizarPosicionCamara()

func _ajustarZoom(delta: float) -> void:
	distanciaActual = clamp(distanciaActual + delta, Constantes.DISTANCIA_MINIMA_CAMARA, Constantes.DISTANCIA_MAXIMA_CAMARA)
	_actualizarPosicionCamara()

func _actualizarPosicionCamara() -> void:
	var desplazamiento: Vector3 = _calcularDesplazamientoCamara()
	var nuevaPosicion: Vector3 = global_position + desplazamiento
	nuevaPosicion.y = max(nuevaPosicion.y, Constantes.ALTURA_MINIMA_CAMARA)
	camara.global_position = nuevaPosicion
	camara.look_at(global_position, Vector3.UP)

func _calcularDesplazamientoCamara() -> Vector3:
	var x: float = cos(rotacionVertical) * sin(rotacionHorizontal)
	var y: float = sin(rotacionVertical)
	var z: float = cos(rotacionVertical) * cos(rotacionHorizontal)
	return Vector3(x, y, z) * distanciaActual

func _inicializarDesdeCamara() -> void:
	var desplazamiento: Vector3 = camara.global_position - global_position
	distanciaActual = desplazamiento.length()
	rotacionHorizontal = atan2(desplazamiento.x, 0)
	rotacionVertical = asin(clamp(desplazamiento.y / distanciaActual, -1.0, 1.0))
	rotacionVertical = clamp(rotacionVertical, Constantes.ANGULO_VERTICAL_MINIMO_CAMARA, Constantes.ANGULO_VERTICAL_MAXIMO_CAMARA)
	distanciaActual = clamp(distanciaActual, Constantes.DISTANCIA_MINIMA_CAMARA, Constantes.DISTANCIA_MAXIMA_CAMARA)
