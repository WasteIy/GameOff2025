extends Node

signal settings_update

# Sensibilidade padrão
@export var mouse_sensibility_x: float = 0.2:
	set(value):
		mouse_sensibility_x = value
		settings_update.emit()

@export var mouse_sensibility_y: float = 0.2:
	set(value):
		mouse_sensibility_y = value
		settings_update.emit()

@export var master_volume: float = -20:
	set(value):
		master_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

@export var master_volume_muted: bool = false:
	set(value):
		master_volume_muted = value
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value)

@export var fov: float = 75.0:
	set(value):
		fov = value
		settings_update.emit()

func set_mouse_sensibility(x: float, y: float) -> void:
	mouse_sensibility_x = x
	mouse_sensibility_y = y

func get_mouse_sensibility() -> Vector2:
	return Vector2(mouse_sensibility_x, mouse_sensibility_y)
