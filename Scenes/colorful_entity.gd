extends Node3D
class_name ColorfulEntity

@export var color: GameManager.ColorEnum


func _ready() -> void:
	GameManager.color_changed.connect(_on_color_changed)
	_on_color_changed(GameManager.active_color)


func _on_color_changed(active_color: GameManager.ColorEnum) -> void:
	visible = (color == active_color)
