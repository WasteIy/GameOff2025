class_name InAirState extends State

var character : CharacterBody3D

func enter(character_reference : CharacterBody3D):
	character = character_reference
	
	if character.hit_ground_cooldown != character.hit_ground_cooldown_reference:
		character.hit_ground_cooldown = character.hit_ground_cooldown_reference

func physics_update(delta : float):
	update(delta)
	character.apply_gravity(delta)
	check_input()
	check_if_floor()
	move(delta)

func update(delta : float):
	if !character.is_on_floor():
		if character.coyote_jump_cooldown > 0.0:
			character.coyote_jump_cooldown -= delta
	
	character.tween_collision_height(character.base_collision_height)
	character.tween_model_height(character.base_model_height)

func check_input():
	if Input.is_action_just_pressed("jump"):
		# Buffered jump
		if character.floor_check.is_colliding() and character.last_frame_position.y > character.position.y and character.number_air_jump <= 0:
			character.buffered_jump_on = true
		
		# Coyote jump
		if character.was_on_floor and character.coyote_jump_cooldown > 0.0 and character.last_frame_position.y > character.position.y:
			character.coyote_jump_on = true
			transitioned.emit(self, "JumpState")
			return
		
		transitioned.emit(self, "JumpState")
		return
		
	if Input.is_action_just_pressed("crouch"):
		if character.slide_floor_check.is_colliding() and character.last_frame_position.y > character.position.y and character.slide_cooldown <= 0.0:
			character.slide_buffering_on = true

func check_if_floor():
	if character.is_on_floor():
		if character.buffered_jump_on:
			character.buffered_jump = true
			character.buffered_jump_on = false
			transitioned.emit(self, "JumpState")
			return
		if character.slide_buffering_on:
			character.slide_buffering_on = false
			transitioned.emit(self, "SlideState")
			return
		else:
			if character.move_direction:
				transitioned.emit(self, character.walk_or_run)
			else:
				transitioned.emit(self, "IdleState")
				return
	
	if character.is_on_wall():
		character.velocity.x = 0.0
		character.velocity.z = 0.0

func move(delta : float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction = (character.camera_controller.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	if !character.is_on_floor():
		if character.move_direction:
			if character.desired_move_speed < character.max_speed:
				character.desired_move_speed += character.bunny_hop_desired_move_speed_increase * delta

			var controled_desired_move_speed : float = character.desired_move_speed_curve.sample(character.desired_move_speed)
			var controled_in_air_move_speed : float = character.in_air_move_speed_curve.sample(character.desired_move_speed) * character.in_air_input_multiplier

			character.velocity.x = lerp(character.velocity.x, character.move_direction.x * controled_desired_move_speed, controled_in_air_move_speed * delta)
			character.velocity.z = lerp(character.velocity.z, character.move_direction.z * controled_desired_move_speed, controled_in_air_move_speed * delta)
		else:
			character.desired_move_speed = character.velocity.length()

	if character.desired_move_speed >= character.max_speed:
		character.desired_move_speed = character.max_speed
