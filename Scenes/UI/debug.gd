extends CanvasLayer

@export var player : CharacterBody3D

@onready var velocity_label: Label = %VelocityLabel
@onready var coyote_cooldown_label: Label = $"Player Info/VBoxContainer2/CoyoteCooldownLabel"

func _process(_delta : float) -> void:
	display()
	
func display():
	velocity_label.set_text(str(player.velocity.length()))
	coyote_cooldown_label.set_text(str(player.coyote_jump_cooldown))
