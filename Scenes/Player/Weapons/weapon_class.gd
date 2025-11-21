class_name Weapon extends Node3D

signal shoot_animation
signal reload_animation

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

@export_group("Sway Variables")
@export var sway_min : Vector2 = Vector2(-10.0, -10.0)
@export var sway_max : Vector2 = Vector2(10.0, 10.0)
@export_range(0,0.2,0.01) var sway_speed_position : float = 0.07
@export_range(0,0.2,0.01) var sway_speed_rotation : float = 0.1
@export_range(0,0.25,0.01) var sway_ammount_position : float = 0.1
@export_range(0,50,0.1) var sway_ammount_rotation : float = 30.0
@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2

var mouse_movement : Vector2
var random_sway_x 
var random_sway_y
var random_sway_amount = 5.0
var time : float = 0.0
var idle_sway_adjustment = 10.0
var idle_sway_rotation_strenght = 30.0

@onready var mesh_container: Node3D = $MeshContainer
@onready var bullet_spawn_point: Marker3D = $BulletSpawnPoint
@onready var animation_manager: AnimationPlayer = $AnimationManager

var player : CharacterBody3D

func enter(player_reference):
	player = player_reference

func _ready():
	if animation_manager:
		shoot_animation.connect(animation_manager._on_shoot_animation)
		reload_animation.connect(animation_manager._on_reload_animation)

func _physics_process(delta: float) -> void:
	sway_weapon(delta)

func sway_weapon(delta) -> void:
	mouse_movement = mouse_movement.clamp(sway_min, sway_max)
	
	var sway_random : float = get_sway_noise()
	var sway_random_adjusted : float = sway_random * idle_sway_adjustment
	
	time += delta * (sway_speed + sway_random)
	
	random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
	random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount
	
	position.x = lerp(position.x, mesh_container.position.x - (mouse_movement.x * sway_ammount_position + random_sway_x) * delta, sway_speed_position)
	position.y = lerp(position.y, mesh_container.position.y + (mouse_movement.y * sway_ammount_position + random_sway_y) * delta, sway_speed_position)
	rotation_degrees.y = lerp(rotation_degrees.y, mesh_container.rotation_degrees.y + (mouse_movement.y * sway_ammount_rotation) * delta, sway_speed_rotation)
	rotation_degrees.x = lerp(rotation_degrees.y, mesh_container.rotation_degrees.y - (mouse_movement.x * sway_ammount_rotation) * delta, sway_speed_rotation)

func get_sway_noise() -> float:
	var player_position : Vector3 = Vector3(0,0,0)
	if not Engine.is_editor_hint():
		player_position = player.global_position
	var noise_location : float = sway_noise.noise.get_noise_2d(player_position.x,player_position.y)
	return noise_location

func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func shoot():
	ammo_in_mag -= 1
	fire_bullet()
	emit_signal("shoot_animation")

func reload():
	var needed = mag_capacity - ammo_in_mag
	if infinite_total_ammo:
		ammo_in_mag = mag_capacity
	else:
		var load_amount = min(needed, total_ammo)
		ammo_in_mag += load_amount
		total_ammo -= load_amount
	emit_signal("reload_animation")

func fire_bullet():
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = bullet_spawn_point.global_transform

func get_shoot_duration() -> float:
	if animation_manager == null:
		return fallback_shoot_cooldown
	var animation = animation_manager.get_animation("shoot")
	if animation == null:
		return fallback_shoot_cooldown
	return animation.length - early_shoot_time if early_shoot else animation.length

func get_reload_duration() -> float:
	if animation_manager == null:
		return fallback_reload_cooldown
	var animation = animation_manager.get_animation("reload")
	if animation == null:
		return fallback_reload_cooldown
	return animation.length - early_reload_time if early_reload else animation.length
