extends Node3D
class_name CameraObject

@export var x_sensibility: float = 0.2
@export var y_sensibility: float = 0.2
@export_range(-89.0, 89.0) var min_pitch: float = -70.0
@export_range(-89.0, 89.0) var max_pitch: float = 70.0

@onready var camera: Camera3D = $Camera
@onready var player: PlayerCharacter = $".."

var pitch: float = 0.0
var mouse_free: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		mouse_free = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if mouse_free and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		mouse_free = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if not mouse_free and event is InputEventMouseMotion:
		player.rotate_y(-deg_to_rad(event.relative.x * x_sensibility))
		
		pitch = clamp(pitch - event.relative.y * y_sensibility, min_pitch, max_pitch)
		camera.rotation_degrees.x = pitch
