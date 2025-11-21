class_name WeaponManager
extends Node3D

enum WeaponState { IDLE, SHOOTING, RELOADING }

@export var player : CharacterBody3D

var weapons: Array[Weapon] = []
var current_weapon: Weapon = null
var state: WeaponState = WeaponState.IDLE
var shoot_cooldown := 0.0
var reload_cooldown := 0.0
var reload_canceled := false

func _ready():
	for child in get_children():
		if child is Weapon:
			weapons.append(child)
	if weapons.size() == 0:
		return
	current_weapon = weapons[0]
	current_weapon.enter(player)

func _process(delta):
	update_shoot_cooldown(delta)
	update_reload(delta)

func try_shoot():
	if current_weapon == null:
		return
	if current_weapon.ammo_in_mag <= 0:
		if state == WeaponState.IDLE:
			try_reload()
		return
	if state == WeaponState.RELOADING:
		if current_weapon.ammo_in_mag > 0:
			reload_canceled = true
			state = WeaponState.IDLE
		else:
			return
	if state != WeaponState.IDLE:
		return
	if shoot_cooldown > 0.0:
		return
	current_weapon.shoot()
	state = WeaponState.SHOOTING
	shoot_cooldown = current_weapon.get_shoot_duration()

func try_reload():
	if current_weapon == null:
		return
	if state != WeaponState.IDLE:
		return
	if !current_weapon.infinite_total_ammo and current_weapon.total_ammo <= 0:
		return
	if current_weapon.ammo_in_mag == current_weapon.mag_capacity:
		return
	state = WeaponState.RELOADING
	reload_canceled = false
	current_weapon.emit_signal("reload_animation")
	reload_cooldown = current_weapon.get_reload_duration()

func update_shoot_cooldown(delta):
	if shoot_cooldown > 0.0:
		shoot_cooldown -= delta
		if shoot_cooldown <= 0.0 and state == WeaponState.SHOOTING:
			state = WeaponState.IDLE

func update_reload(delta):
	if state != WeaponState.RELOADING:
		return
	reload_cooldown -= delta
	if reload_cooldown <= 0.0:
		if reload_canceled:
			state = WeaponState.IDLE
			return
		current_weapon.reload()
		state = WeaponState.IDLE

func _on_shoot_input():
	try_shoot()

func _on_reload_input():
	try_reload()
