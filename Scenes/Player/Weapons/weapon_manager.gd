class_name WeaponManager
extends Node3D

var weapons: Array[Weapon] = []
var current_weapon: Weapon = null


func _ready():
	for child in get_children():
		if child is Weapon:
			weapons.append(child)
	
	if weapons.size() == 0:
		push_warning("Nenhuma arma encontrada")
		return
		
	current_weapon = weapons[0]
	
	current_weapon.weapon_fired.connect(_on_weapon_fired)
	current_weapon.weapon_reloaded.connect(_on_weapon_reloaded)

func try_shoot():
	if current_weapon:
		current_weapon.shoot()

func try_reload():
	if current_weapon:
		current_weapon.reload()

func _on_weapon_fired():
	# TODO Animação
	pass

func _on_weapon_reloaded():
	# TODO Animação
	pass

func _on_shoot_input():
	try_shoot()

func _on_reload_input():
	try_reload()
