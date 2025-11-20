extends AnimationPlayer

@export var max_animation_speed : float = 5.0

@onready var player: Player = $".."

func _physics_process(_delta: float) -> void:
	set_animation_speed(player.velocity.length())

func play_state_animation(state_name: String) -> void:
	var animation_name := state_name
	if not has_animation(animation_name):
		return
	
	var t := 0.0
	
	if current_animation:
		t = current_animation_position
	
	play(animation_name)
	seek(t, false)

func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, player.max_speed, 0.0, 2.0)
	speed_scale = clamp(lerp(0.0, max_animation_speed, alpha), 0.0, max_animation_speed)
