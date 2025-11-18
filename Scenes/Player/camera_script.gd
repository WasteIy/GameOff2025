class_name CameraController extends Node3D

@export_range(-90.0, 90.0) var min_pitch: float = -90.0
@export_range(-90.0, 90.0) var max_pitch: float = 90.0

@onready var camera: Camera3D = $Camera
@onready var player: Player = $".."

var pitch: float = 0.0
var mouse_free: bool = false

var x_sensibility: float
var y_sensibility: float

func _ready() -> void:
	update_sensibility_and_fov()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameController.settings_update.connect(on_settings_update)

func on_settings_update():
	update_sensibility_and_fov()

func update_sensibility_and_fov() -> void:
	# Essa função serve pra no futuro, sempre que atualizar no menu a sensibilidade e FOV
	# chamar essa função via signal. Tive problemas com sensibilidade em outra jam que participei
	
	x_sensibility = GameController.mouse_sensibility_x
	y_sensibility = GameController.mouse_sensibility_y
	camera.fov = GameController.fov

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
