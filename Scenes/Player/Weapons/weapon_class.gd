class_name Weapon extends Node3D

signal shoot_animation
signal reload_animation

enum WeaponState { IDLE, SHOOTING, RELOADING }
var state: WeaponState = WeaponState.IDLE

@export_group("Ammunition Variables")
@export var ammo_in_mag := 10
@export var mag_capacity := 10
@export var total_ammo := 0
@export var infinite_total_ammo := true
@export var bullet_scene: PackedScene

@export_group("Cooldown Variables")
@export var early_reload : bool = true
@export var early_reload_time : float = 0.1
@export var early_shoot : bool = true
@export var early_shoot_time : float = 0.1
@export var fallback_shoot_cooldown := 0.2
@export var fallback_reload_cooldown := 0.4

@onready var bullet_spawn_point: Marker3D = $BulletSpawnPoint
@onready var animation_manager: AnimationPlayer = $AnimationManager

var shoot_cooldown := 0.0
var reload_cooldown := 0.0
var reload_cancelled := false

func _ready():
	if animation_manager:
		shoot_animation.connect(animation_manager._on_shoot_animation)
		reload_animation.connect(animation_manager._on_reload_animation)

func _process(delta: float) -> void:
	update_shoot_cooldown(delta)
	update_reload(delta)

func update_shoot_cooldown(delta: float) -> void:
	if shoot_cooldown > 0.0:
		shoot_cooldown -= delta
		if shoot_cooldown <= 0.0 and state == WeaponState.SHOOTING:
			state = WeaponState.IDLE

func update_reload(delta: float) -> void:
	if state != WeaponState.RELOADING:
		return
	reload_cooldown -= delta
	if reload_cooldown <= 0.0:
		if reload_cancelled:
			state = WeaponState.IDLE
			return
	
		var needed = mag_capacity - ammo_in_mag
		if infinite_total_ammo:
			ammo_in_mag = mag_capacity
		else:
			var load_amount = min(needed, total_ammo)
			ammo_in_mag += load_amount
			total_ammo -= load_amount
		state = WeaponState.IDLE

func shoot():
	if state == WeaponState.RELOADING:
		reload_cancelled = true
		state = WeaponState.IDLE
	if state != WeaponState.IDLE:
		return
	if shoot_cooldown > 0.0:
		return
	if ammo_in_mag <= 0:
		return
	
	ammo_in_mag -= 1
	fire_bullet()
	emit_signal("shoot_animation")
	state = WeaponState.SHOOTING
	shoot_cooldown = get_animation_duration("shoot", fallback_shoot_cooldown)
	
	if early_shoot:
		shoot_cooldown -= early_shoot_time

func fire_bullet():
	if bullet_scene == null:
		push_error("Não encontrou uma cena para a bullet.")
		return
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = bullet_spawn_point.global_transform

func reload():
	if state != WeaponState.IDLE:
		return
	if !infinite_total_ammo and total_ammo <= 0:
		return
	if ammo_in_mag == mag_capacity:
		return
	state = WeaponState.RELOADING
	reload_cancelled = false
	emit_signal("reload_animation")
	
	reload_cooldown = get_animation_duration("reload", fallback_reload_cooldown)
	
	if early_reload:
		reload_cooldown -= early_reload_time

func get_animation_duration(anim_name: String, fallback: float) -> float:
	if animation_manager == null and !early_reload:
		return fallback
	var anim = animation_manager.get_animation(anim_name)
	if anim == null:
		return fallback
	
	return anim.length
