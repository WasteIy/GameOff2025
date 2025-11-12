class_name WalkState extends State

var character : CharacterBody3D

func enter(character_reference):
	print("Entrei no WalkState")
	character = character_reference
	
	character.move_speed = character.walk_speed
	character.move_acceleration = character.walk_acceleration
	character.move_deceleration = character.walk_deceleration
	
	if character.number_air_jump < character.number_air_jump_reference: 
		character.number_air_jump = character.number_air_jump_reference
	if character.coyote_jump_cooldown < character.coyote_jump_cooldown_reference:
		character.coyote_jump_cooldown = character.coyote_jump_cooldown_reference

func physics_update(delta : float):
	check_if_floor()
	update(delta)
	character.apply_gravity(delta)
	check_input()
	move(delta)

func check_if_floor():
	if !character.is_on_floor() and !character.is_on_wall():
		if character.velocity.y < 0.0:
			transitioned.emit(self, "InAirState")
	if character.is_on_floor():
		if character.buffered_jump_on:
			character.buffered_jump = true
			character.buffered_jump_on = false
			transitioned.emit(self, "JumpState")

func update(delta):
	if character.hit_ground_cooldown > 0.0: character.hit_ground_cooldown -= delta
	
	character.collision.shape.height = lerp(character.collision.shape.height, character.base_collision_height, character.height_change_speed * delta)
	character.model.scale.y = lerp(character.model.scale.y, character.base_model_height, character.height_change_speed * delta)

func check_input():
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "JumpState")
	
	if Input.is_action_just_pressed("run"):
		character.walk_or_run = "RunState"
		transitioned.emit(self, "RunState")
		
	if Input.is_action_just_pressed("crouch"): 
		transitioned.emit(self, "CrouchState")

func move(delta : float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction = (character.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	if character.move_direction and character.is_on_floor():
		character.velocity.x = lerp(character.velocity.x, character.move_direction.x * character.move_speed, character.move_acceleration * delta)
		character.velocity.z = lerp(character.velocity.z, character.move_direction.z * character.move_speed, character.move_acceleration * delta)
		
		if character.hit_ground_cooldown <= 0: character.desired_move_speed = character.velocity.length()
		
	else:
		transitioned.emit(self, "IdleState")
		
	if character.desired_move_speed >= character.max_speed: character.desired_move_speed = character.max_speed
