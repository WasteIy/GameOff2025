extends AnimationPlayer

@export var max_animation_speed : float = 5.0

@onready var player: Player = $".."

func _physics_process(_delta: float) -> void:
	set_animation_speed(player.velocity.length())

func play_state_animation(state_name: String) -> void:
	var animation_name := state_name
	if has_animation(animation_name):
		play(animation_name)

func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, player.max_speed, 0.0, 2.0)
	speed_scale = lerp(0.0, max_animation_speed, alpha)
