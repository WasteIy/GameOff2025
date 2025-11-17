class_name SlideState extends State

var character : CharacterBody3D

var slope_angle : float

func enter(character_reference : CharacterBody3D) -> void:
	character = character_reference
	
	character.move_speed = character.slide_speed
	character.move_acceleration = character.slide_acceleration
	character.move_deceleration = 0.0
	
	# Pega a direção antes de começar o slide, e só usa ela
	character.slide_direction = character.move_direction.normalized() 
	
	character.slide_time = character.slide_time_reference
	if character.number_air_jump < character.number_air_jump_reference: 
		character.number_air_jump = character.number_air_jump_reference
	if character.coyote_jump_cooldown < character.coyote_jump_cooldown_reference:
		character.coyote_jump_cooldown = character.coyote_jump_cooldown_reference

func physics_update(delta : float) -> void:
	check_if_floor()
	update(delta)
	character.apply_gravity(delta)
	check_input()
	move(delta)
	
func check_if_floor() -> void:
	if character.is_on_floor():
		if character.buffered_jump_on:
			character.buffered_jump = true
			transitioned.emit(self, "JumpState")

func update(delta : float) -> void:
	if (character.global_position.y - character.last_frame_position.y) > character.uphill_tolerance:
		# Checa se o player está subindo
		character.slide_time = -1.0
		character.slide_direction = Vector3.ZERO
		if !raycast_check():
			transitioned.emit(self, character.walk_or_run)
		else:
			transitioned.emit(self, "CrouchState")
	
	slope_angle = rad_to_deg(acos(character.get_floor_normal().dot(Vector3.UP)))
	if slope_angle < character.max_slope_angle:
		if character.slide_time > 0.0:
			if character.is_on_floor():
				character.slide_time -= delta
		else:
			character.slide_direction = Vector3.ZERO
			character.slide_cooldown = character.slide_cooldown_reference
			if !raycast_check():
				transitioned.emit(self, character.walk_or_run)
			else:
				transitioned.emit(self, "CrouchState")
	
	character.tween_collision_height(character.slide_collision_height)
	character.tween_model_height(character.slide_model_height)

func check_input() -> void:
	if Input.is_action_just_pressed("jump"):
		if (slope_angle > character.max_slope_angle or !raycast_check()):
			# Quebra o estado de slide
			character.slide_time = -1.0
			character.slide_direction = Vector3.ZERO
			character.slide_cooldown = character.slide_cooldown_reference
			transitioned.emit(self, "JumpState")
	
	if character.continuous_slide: 
		if Input.is_action_just_pressed("crouch"):
			character.slide_time = -1.0
			character.slide_direction = Vector3.ZERO
			character.slide_cooldown = character.slide_cooldown_reference
			if !raycast_check():
				transitioned.emit(self, character.walk_or_run)
			else:
				transitioned.emit(self, "CrouchState")
	else:
		if !Input.is_action_pressed("crouch"):
			if !raycast_check():
				character.slide_time = -1.0
				character.slide_direction = Vector3.ZERO
				character.slide_cooldown = character.slide_cooldown_reference
				if !raycast_check():
					transitioned.emit(self, character.walk_or_run)
				else:
					transitioned.emit(self, "CrouchState")

func raycast_check() -> bool:
	return character.ceiling_check.is_colliding()

func move(delta : float) -> void:
	# Não muda a direção enquanto deslizando
	if character.slide_direction and character.is_on_floor():
		if character.desired_move_speed:
			character.desired_move_speed = clamp(character.desired_move_speed, 0.0, character.max_speed)
			
			if slope_angle < character.max_slope_angle and (character.desired_move_speed - character.velocity_lost_per_second * delta > 0.0):
				character.desired_move_speed -= character.velocity_lost_per_second * delta
			else: 
				character.desired_move_speed += character.slope_sliding_desired_move_speed_increase * delta
			
			character.velocity.x = character.move_direction.x * character.desired_move_speed
			character.velocity.z = character.move_direction.z * character.desired_move_speed
	
		else:
			if slope_angle < character.max_slope_angle and (character.desired_move_speed - character.velocity_lost_per_second * delta > 0.0): 
				character.move_speed -= character.velocity_lost_per_second * delta
			else: 
				character.move_speed += character.slope_sliding_speed_increase * delta
			
			character.velocity.x = lerp(character.velocity.x, character.move_direction.x * character.move_speed, character.move_acceleration * delta)
			character.velocity.z = lerp(character.velocity.z, character.move_direction.z * character.move_speed, character.move_acceleration * delta)
