extends Node
@onready var gun: MeshInstance3D = $Enemy/Gun
var parent: Node = get_parent()
var rotation_speed_x: float

func _ready() -> void:
	if parent:
		rotation_speed_x = parent.getRotationX()
	else:
		rotation_speed_x = 100

func physics_update(delta: float) -> void:
	gun.rotation_degrees.x += rotation_speed_x * delta
	pass
