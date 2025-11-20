extends Node3D
@export var target: CharacterBody3D
@export var fire_speed: int 
@export var rotation_speed_x: float 
@export var rotation_speed_y: float 
@export var rotation_acceleration: float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detection_range_body_entered(body_reference: CharacterBody3D) -> void:
	pass # Replace with function body.


func getRotationSpeedX():
	return rotation_speed_x
