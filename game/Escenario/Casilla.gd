class_name Casilla
extends Area3D

signal casillaClickeada(posicion: Vector2i)

@export var posicionCuadricula: Vector2i = Vector2i.ZERO

var cursorEncima: bool = false
var bloqueada: bool = false
var estaDisponible: bool = false

var mesh: MeshInstance3D
var material: StandardMaterial3D

func _ready() -> void:
	mesh = $MeshInstance3D
	_actualizarColor()

func _actualizarColor() -> void:
	if mesh == null:
		return

	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()

	material = mesh.material_override

	if cursorEncima:
		material.albedo_color = Constantes.COLOR_CURSOR_ENCIMA
	elif estaDisponible:
		material.albedo_color = Constantes.COLOR_DISPONIBLE
	else:
		material.albedo_color = Constantes.COLOR_NORMAL

func _on_input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if bloqueada:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		casillaClickeada.emit(posicionCuadricula)

func _on_mouse_entered() -> void:
	if bloqueada:
		return

	cursorEncima = true
	_actualizarColor()

func _on_mouse_exited() -> void:
	cursorEncima = false
	_actualizarColor()

func setDisponible(valor: bool) -> void:
	estaDisponible = valor
	_actualizarColor()

func setBloqueada(valor: bool) -> void:
	bloqueada = valor

	if bloqueada:
		cursorEncima = false

	_actualizarColor()
