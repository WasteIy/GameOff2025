class_name Weapon extends Node3D

signal weapon_fired(weapon : Weapon)
signal weapon_reloaded(weapon : Weapon)

@export var weapon_name : String = "No Weapon"
@export var fire_rate : float = 0.2
@export var ammo_in_mag : int = 10
@export var mag_capacity : int = 10
@export var total_ammo : int = 30

var can_fire : bool = true
var is_reloading : bool = false
var manager : Node = null

func _ready() -> void:
	pass 

func fire() -> void:
	if not can_fire or is_reloading:
		return
	
	if ammo_in_mag <= 0:
		_play_empty_click()
		return
	
	ammo_in_mag -= 1
	emit_signal("weapon_fired", self)
	_shoot_effects()
	
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func reload() -> void:
	if is_reloading:
		return
	if ammo_in_mag >= mag_capacity or total_ammo <= 0:
		return
	
	is_reloading = true
	emit_signal("weapon_reloaded", self)
	
	await get_tree().create_timer(_reload_time()).timeout
	
	var needed = mag_capacity - ammo_in_mag
	var loaded = min(needed, total_ammo)
	
	ammo_in_mag += loaded
	total_ammo -= loaded
	
	is_reloading = false

func on_equip() -> void:
	visible = true
	can_fire = true
	is_reloading = false
	print("%s equipped" % weapon_name)

func on_unequip() -> void:
	visible = false
	can_fire = false
	is_reloading = false
	print("%s unequipped" % weapon_name)


func _shoot_effects() -> void:
	pass

func _play_empty_click() -> void:
	pass

func _reload_time() -> float:
	return 1.5
