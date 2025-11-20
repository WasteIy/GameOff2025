class_name JumpState extends State

var character : CharacterBody3D

func enter(character_reference: CharacterBody3D):
	character = character_reference
	
	if character.hit_ground_cooldown != character.hit_ground_cooldown:
		character.hit_ground_cooldown = character.hit_ground_cooldown
	
	jump()

func physics_update(delta: float):
	update(delta)
	character.apply_gravity(delta)
	check_input()
	check_if_floor()
	move(delta)

func update(delta: float):
	if !character.is_on_floor(): 
		if character.coyote_jump_cooldown > 0.0:
			character.coyote_jump_cooldown -= delta
	
	character.tween_collision_height(character.base_collision_height)
	character.tween_model_height(character.base_model_height)

func check_input():
	if Input.is_action_just_pressed("jump"):
		jump()

func check_if_floor():
	if !character.is_on_floor() and character.velocity.y < 0.0:
		transitioned.emit(self, "InAirState")
		return
		
	if character.is_on_floor():
		if character.move_direction:
			transitioned.emit(self, character.walk_or_run)
			return
		else:
			transitioned.emit(self, "IdleState")
			return
	
	# Perde toda a velocidade se o personagem bater numa parede
	if character.is_on_wall():
		character.velocity.x = 0.0
		character.velocity.z = 0.0

func move(delta: float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction = (character.camera_controller.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	# Movimento só é aplicado quando o personagem está no ar
	if !character.is_on_floor():
		if character.move_direction:
			if character.desired_move_speed < character.max_speed:
				character.desired_move_speed += character.bunny_hop_desired_move_speed_increase * delta
			
			var controlled_desired_move_speed: float = character.desired_move_speed_curve.sample(character.desired_move_speed)
			var controlled_in_air_move_speed: float = character.in_air_move_speed_curve.sample(character.desired_move_speed) * character.in_air_input_multiplier
			
			character.velocity.x = lerp(character.velocity.x, character.move_direction.x * controlled_desired_move_speed, controlled_in_air_move_speed * delta)
			character.velocity.z = lerp(character.velocity.z, character.move_direction.z * controlled_desired_move_speed, controlled_in_air_move_speed * delta)

			if character.velocity.length() > character.max_speed:
				character.velocity = character.velocity.normalized() * character.max_speed
		else:
			# Acumula a velocidade desejada para bunny hopping
			character.desired_move_speed = character.velocity.length()
			
	if character.desired_move_speed >= character.max_speed:
		character.desired_move_speed = character.max_speed

func jump(): 
	var can_jump: bool = false
	
	# pulo no ar
	if !character.is_on_floor():
		if !character.coyote_jump_on and character.number_air_jump > 0:
			character.number_air_jump -= 1
			can_jump = true 
		if character.coyote_jump_on:
			character.coyote_jump_cooldown = -1.0 # impede outro pulo coyote imediato
			character.coyote_jump_on = false
			can_jump = true 
			
	# Pulo no chão
	if character.is_on_floor():
		can_jump = true 
		
	# Buffer de pulo
	if character.buffered_jump:
		character.buffered_jump = false
		character.number_air_jump = character.number_air_jump_reference
		
	# Aplica o pulo
	if can_jump:
		character.velocity.y = character.jump_velocity
		can_jump = false
