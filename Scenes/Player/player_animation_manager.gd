extends AnimationPlayer

@export var max_animation_speed: float = 5.0

@onready var player: Player = $".."

var current_speed_scale := 1.0

func _physics_process(_delta: float) -> void:
	var state := player.state_machine.current_state.name
	var active_state := state == "WalkState" or state == "RunState" or state == "CrouchState"

	if active_state:
		sync_bob()
	else:
		stop_bob()
	
	set_animation_speed(player.velocity.length())
	current_speed_scale = speed_scale

func play_state_animation(state_name: String) -> void:
	if not has_animation(state_name):
		return
	
	play(state_name)
	seek(current_animation_position, false)

func set_animation_speed(speed: float) -> void:
	var alpha := remap(speed, 0.0, player.max_speed, 0.0, 2.0)
	speed_scale = clamp(lerp(0.0, max_animation_speed, alpha), 0.0, max_animation_speed)

func sync_bob() -> void:
	var weapon_animation = player.weapon_manager.bob_animation
	if weapon_animation == null:
		return
	
	var time := 0.0
	if weapon_animation.current_animation == "bob":
		time = weapon_animation.current_animation_position
	
	if weapon_animation.current_animation != "bob":
		weapon_animation.play("bob")
	
	weapon_animation.seek(time, false)
	weapon_animation.speed_scale = current_speed_scale

func stop_bob() -> void:
	var weapon_animation = player.weapon_manager.bob_animation
	if weapon_animation == null:
		return
	
	if weapon_animation.current_animation == "bob":
		weapon_animation.stop()
		# Isso é porque quando tocava a animação de atirar ou de recarregar, ela tocava muito rápido
		weapon_animation.speed_scale = 1.0
