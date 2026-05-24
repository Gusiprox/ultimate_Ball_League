class_name Casilla
extends Area3D

signal casillaClickeada(posicion: Vector2i)

@export var posicionCuadricula: Vector2i = Vector2i.ZERO

var mesh: MeshInstance3D
var hover: bool = false
var estaDisponible: bool = false

func _ready() -> void:
	mesh = $MeshInstance3D
	_inicializarSeñales()
	_actualizarColor()

func _inicializarSeñales() -> void:
	mouse_entered.connect(_onMouseEntered)
	mouse_exited.connect(_onMouseExited)
	input_event.connect(_onInputEvent)

func _onInputEvent(
	_camera: Camera3D,
	event: InputEvent,
	_world_position: Vector3,
	_world_normal: Vector3,
	_shape_index: int
) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		casillaClickeada.emit(posicionCuadricula)

func _onMouseEntered() -> void:
	hover = true
	_actualizarColor()

func _onMouseExited() -> void:
	hover = false
	_actualizarColor()

func setDisponible(valor: bool) -> void:
	estaDisponible = valor
	_actualizarColor()

func _actualizarColor() -> void:
	if mesh == null:
		return

	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()

	var material: StandardMaterial3D = mesh.material_override

	if hover:
		material.albedo_color = Constantes.COLOR_HOVER
	elif estaDisponible:
		material.albedo_color = Constantes.COLOR_DISPONIBLE
	else:
		material.albedo_color = Constantes.COLOR_NORMAL
