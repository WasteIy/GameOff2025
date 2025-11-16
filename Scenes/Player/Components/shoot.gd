class_name ShootInput extends Node

signal shoot_input
signal reload_input

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot_input.emit()
	if Input.is_action_just_pressed("reload"):
		reload_input.emit()
