class_name IdleState extends State

var character : CharacterBody3D

func enter(character_reference):
	print("Entrei no IdleState")
	character = character_reference

func physics_update(delta: float) -> void:
#	check_is_on_floor()
	character.apply_gravity(delta)
	check_input()
	move(delta)
	
#func check_is_on_floor():
#	if !character.is_on_floor():
#		transitioned.emit(self, "InAirState")

func check_input():
	pass
	
func move(delta : float):
	character.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_direction  = (character.global_basis * Vector3(character.input_direction.x, 0.0, character.input_direction.y)).normalized()
	
	if character.move_direction and character.is_on_floor():
		transitioned.emit(self, character.walk_or_run)
		
	else:
		# Desacelera suavemente 
		character.velocity.x = lerp(character.velocity.x, 0.0, character.move_deceleration * delta)
		character.velocity.z = lerp(character.velocity.z, 0.0, character.move_deceleration * delta)
