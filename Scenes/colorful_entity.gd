extends Node3D
class_name ColorfulEntity

@export var color: GameManager.ColorEnum
var is_active: bool = false

func _ready() -> void:
	GameManager.color_changed.connect(_on_color_changed)
	_on_color_changed(GameManager.active_color)


func _on_color_changed(active_color: GameManager.ColorEnum) -> void:
	is_active = (color == active_color)
	_set_active(is_active)

func _set_active(active: bool) -> void:
	is_active = active 
