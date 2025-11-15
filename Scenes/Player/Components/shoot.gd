extends Node

signal shoot_input

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot_input.emit()
