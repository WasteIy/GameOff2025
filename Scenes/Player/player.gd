class_name Player extends CharacterBody3D


@onready var camera_holder: CameraHolder = $CameraHolder
@onready var state_machine: StateMachine = $StateMachine

func _physics_process(_delta: float) -> void:
	move_and_slide()
