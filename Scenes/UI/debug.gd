extends CanvasLayer

@export var player : CharacterBody3D

@onready var velocity_label: Label = %VelocityLabel

func _process(_delta : float) -> void:
	display()
	
func display():
	velocity_label.set_text(str(player.velocity.length()))
