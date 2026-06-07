extends Node3D

@onready var camara: Camera3D = $Camera3D

var centroX: float
var centroZ: float
var x: float
var y: float
var z: float

var rotacionHorizontal: float = 0.0
var rotacionVertical: float = 0.0
var distanciaActual: float = Constantes.DISTANCIA_INICIAL_CAMARA

var arrastrandoRaton: bool = false

var desplazamiento: Vector3
var nuevaPosicion: Vector3

func _ready() -> void:
	_centrarMapa()
	_inicializarDesdeCamara()
	_actualizarPosicionCamara()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_procesarEntradaRaton(event)
	elif event is InputEventMouseMotion and arrastrandoRaton:
		_procesarMovimientoRaton(event)

func _centrarMapa() -> void:
	centroX = (Constantes.ANCHO_MAPA - 1) * Constantes.TAMANO_CASILLA / 2
	centroZ = (Constantes.LARGO_MAPA - 1) * Constantes.TAMANO_CASILLA / 2
	global_position = Vector3(centroX, 0, centroZ)

func _procesarEntradaRaton(event: InputEventMouseButton) -> void:
	match event.button_index:
		MOUSE_BUTTON_RIGHT:
			arrastrandoRaton = event.pressed
		MOUSE_BUTTON_WHEEL_UP:
			if event.pressed:
				_ajustarZoom(-Constantes.VELOCIDAD_ZOOM_CAMARA)
		MOUSE_BUTTON_WHEEL_DOWN:
			if event.pressed:
				_ajustarZoom(Constantes.VELOCIDAD_ZOOM_CAMARA)

func _procesarMovimientoRaton(event: InputEventMouseMotion) -> void:
	rotacionHorizontal -= event.relative.x * Constantes.SENSIBILIDAD_CAMARA
	rotacionVertical += event.relative.y * Constantes.SENSIBILIDAD_CAMARA
	rotacionVertical = clamp(rotacionVertical, Constantes.ANGULO_VERTICAL_MINIMO_CAMARA, Constantes.ANGULO_VERTICAL_MAXIMO_CAMARA)
	_actualizarPosicionCamara()

func _ajustarZoom(delta: float) -> void:
	distanciaActual = clamp(distanciaActual + delta, Constantes.DISTANCIA_MINIMA_CAMARA, Constantes.DISTANCIA_MAXIMA_CAMARA)
	_actualizarPosicionCamara()

func _actualizarPosicionCamara() -> void:
	desplazamiento = _calcularDesplazamientoCamara()
	nuevaPosicion = global_position + desplazamiento
	
	nuevaPosicion.y = max(nuevaPosicion.y, Constantes.ALTURA_MINIMA_CAMARA)
	camara.global_position = nuevaPosicion
	camara.look_at(global_position, Vector3.UP)

func _calcularDesplazamientoCamara() -> Vector3:
	x = cos(rotacionVertical) * sin(rotacionHorizontal)
	y = sin(rotacionVertical)
	z = cos(rotacionVertical) * cos(rotacionHorizontal)
	
	return Vector3(x, y, z) * distanciaActual

func _inicializarDesdeCamara() -> void:
	desplazamiento = camara.global_position - global_position
	
	distanciaActual = desplazamiento.length()
	rotacionHorizontal = atan2(desplazamiento.x, 0)
	rotacionVertical = asin(clamp(desplazamiento.y / distanciaActual, -1.0, 1.0))
	rotacionVertical = clamp(rotacionVertical, Constantes.ANGULO_VERTICAL_MINIMO_CAMARA, Constantes.ANGULO_VERTICAL_MAXIMO_CAMARA)
	distanciaActual = clamp(distanciaActual, Constantes.DISTANCIA_MINIMA_CAMARA, Constantes.DISTANCIA_MAXIMA_CAMARA)
