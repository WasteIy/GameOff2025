class_name IdleState extends State

var character : CharacterBody3D

func enter(character_reference):
	print("Entrei no IdleState")
	character = character_reference
	
	flag_update()

func flag_update():
	character.floor_snap_length = 1.0
	if character.number_air_jump < character.number_air_jump_reference: character.number_air_jump = character.number_air_jump_reference
	if character.coyote_jump_cooldown < character.coyote_jump_cooldown_reference: character.coyote_jump_cooldown = character.coyote_jump_cooldown_reference

func physics_update(delta: float) -> void:
	check_is_on_floor()
	applies(delta)
	character.apply_gravity(delta)
	check_input()
	move(delta)

func check_is_on_floor():
	if !character.is_on_floor():
		transitioned.emit(self, "InAirState")
	if character.is_on_floor():
		if character.buffered_jump_on: 
			character.buffered_jump = true
			character.buffered_jump_on = false
			transitioned.emit(self, "JumpState")

func applies(delta):
	if character.hit_ground_cooldown > 0.0: character.hit_ground_cooldown -= delta

func check_input():
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "JumpState")

func move(delta : float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction  = (character.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	if character.move_direction and character.is_on_floor():
		transitioned.emit(self, character.walk_or_run)
		
	else:
		# Desacelera suavemente 
		character.velocity.x = lerp(character.velocity.x, 0.0, character.move_deceleration * delta)
		character.velocity.z = lerp(character.velocity.z, 0.0, character.move_deceleration * delta)
		
		if character.hit_ground_cooldown <= 0: character.desired_move_speed = character.velocity.length()
