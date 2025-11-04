extends Node

@export var mouse_sensibility_x: float = 0.2
@export var mouse_sensibility_y: float = 0.2

@export var master_volume: float = 1.0
@export var fov: float = 75.0

func set_mouse_sensibility(x: float, y: float) -> void:
	mouse_sensibility_x = x
	mouse_sensibility_y = y

func get_mouse_sensibility() -> Vector2:
	return Vector2(mouse_sensibility_x, mouse_sensibility_y)
