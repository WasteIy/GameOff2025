class_name CrouchState extends State

var character : CharacterBody3D

func enter(character_reference : CharacterBody3D) -> void:
	character = character_reference
	
	character.move_speed = character.crouch_speed
	character.move_acceleration = character.crouch_acceleration
	character.move_deceleration = character.crouch_deceleration
	
	if character.number_air_jump < character.number_air_jump_reference:
		character.number_air = character.number_air_jump_reference
	if character.coyote_jump_cooldown < character.coyote_jump_cooldown_reference:
		character.coyote_jump_cooldown = character.coyote_jump_cooldown_reference

func physics_update(delta : float) -> void:
	check_if_floor()
	update(delta)
	character.apply_gravity(delta)
	check_input()
	move(delta)

func check_if_floor() -> void:
	if !character.is_on_floor() and !character.is_on_wall():
		if character.velocity.y < 0.0:
			transitioned.emit(self, "InairState")
	if character.is_on_floor():
		if character.buffered_jump_on:
			character.buffered_jump = true
			character.buffered_jump_on = false
			transitioned.emit(self, "JumpState")

func update(delta : float) -> void:
	if character.hit_ground_cooldown > 0.0: character.hit_ground_cooldown -= delta
	
	character.tween_collision_height(character.crouch_collision_height)
	character.tween_model_height(character.crouch_model_height)

func check_input() -> void:
	if Input.is_action_just_pressed("jump"):
		if !raycast_check():
			transitioned.emit(self, "JumpState")
			
	if character.continuous_crouch:
		if Input.is_action_just_pressed("crouch"):
			if !raycast_check():
				character.walk_or_run = "WalkState"
				transitioned.emit(self, "WalkState")
	else:
		if !Input.is_action_pressed("crouch"):
			if !raycast_check():
				character.walk_or_run = "WalkState"
				transitioned.emit(self, "WalkState")
	
	if Input.is_action_just_pressed("run"):
		if !raycast_check():
			character.walk_or_run = "RunState"
			transitioned.emit(self, "RunState")

func raycast_check() -> bool:
	return character.ceiling_check.is_colliding()

func move(delta : float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction = (character.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	if character.move_direction and character.is_on_floor():
		character.velocity.x = lerp(character.velocity.x, character.move_direction.x * character.move_speed, character.move_acceleration * delta)
		character.velocity.z = lerp(character.velocity.z, character.move_direction.z * character.move_speed, character.move_acceleration * delta)
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, character.move_deceleration * delta)
		character.velocity.z = lerp(character.velocity.z, 0.0, character.move_deceleration * delta)
		
	if character.desired_move_speed >= character.max_speed: character.desired_move_speed = character.max_speed
