class_name WeaponManager extends Node3D

signal shoot

var weapon: Weapon = null

func _ready():
	for child in get_children():
		if child is Weapon:
			weapon = child
			break
	
	if weapon == null:
		push_error("Nenhuma arma encontrada.")


func _on_shoot_shoot_input() -> void:
	weapon.shoot()
	emit_signal("shoot")
