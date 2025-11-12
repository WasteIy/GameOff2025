class_name CrouchState extends State

var character : CharacterBody3D

func enter(character_reference : CharacterBody3D) -> void:
	print("Entrei no CrouchState")
	character = character_reference
