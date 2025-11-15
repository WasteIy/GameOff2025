class_name WeaponManager extends Node3D

var weapon: Weapon = null

func _ready():
	for child in get_children():
		if child is Weapon:
			weapon = child
			break

func _on_shoot_input() -> void:
	weapon.shoot()

func _on_reload_input() -> void:
	weapon.reload()


func _on_weapon_fired() -> void:
	pass # Replace with function body.
