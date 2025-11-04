extends CharacterBody3D
class_name PlayerCharacter

func _physics_process(_delta: float) -> void:
	move_and_slide()
