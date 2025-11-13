class_name WeaponManager extends Node3D

var weapons : Dictionary = {}
var current_weapon : Weapon = null
var current_weapon_name : String = ""
var current_index : int = 0

signal weapon_switched(new_weapon_name : String)

func _ready() -> void:
	for child in get_children():
		if child is Weapon:
			child.manager = self
			weapons[child.name.to_lower()] = child
			child.weapon_fired.connect(_on_weapon_fired)
			child.weapon_reloaded.connect(_on_weapon_reloaded)
			
	for weapon in weapons.values():
		weapon.visible = false
	
	if weapons.size() > 0:
		equip_weapon(weapons.keys()[0])

func equip_weapon(weapon_name : String) -> void:
	if current_weapon:
		current_weapon.visible = false
		current_weapon.unequip()
	
	current_weapon = weapons[weapon_name]
	current_weapon_name = weapon_name
	current_weapon.visible = true
	current_weapon.equip()
	
	emit_signal("weapon_switched", weapon_name)

func switch_weapon(direction : int) -> void:
	if weapons.size() <= 1:
		return
		
	var keys = weapons.keys()
	current_index = (current_index + direction) % keys.size()
	if current_index < 0:
		current_index = keys.size() - 1
		
	equip_weapon(keys[current_index])

func shoot_current() -> void:
	if current_weapon:
		current_weapon.shoot()

func reload_current() -> void:
	if current_weapon:
		current_weapon.reload()

func _on_weapon_fired(_weapon_name : String) -> void:
	pass

func _on_weapon_reloaded(_weapon_name : String) -> void:
	pass
