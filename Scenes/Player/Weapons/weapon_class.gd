class_name Weapon
extends Node3D

signal weapon_fired
signal weapon_reloaded

enum WeaponState { IDLE, SHOOTING, RELOADING }
var state: WeaponState = WeaponState.IDLE

@export var shot_interval := 0.2
@export var ammo_in_mag := 10
@export var mag_capacity := 10
@export var total_ammo := 30
@export var bullet_scene: PackedScene

@onready var bullet_spawn_point: Marker3D = $BulletSpawnPoint
@onready var animation_manager: AnimationPlayer = $AnimationManager

var can_shoot := true
var reload_cancelled := false


func _ready():
	if animation_manager:
		weapon_fired.connect(animation_manager._on_weapon_fired)
		weapon_reloaded.connect(animation_manager._on_weapon_reloaded)


func shoot():
	# Se estiver recarregando: interromper
	if state == WeaponState.RELOADING:
		reload_cancelled = true        # Marca cancelamento
		state = WeaponState.IDLE       # Volta para IDLE antes de atirar
	
	# Agora somente atira se puder
	if state != WeaponState.IDLE:
		return
	if !can_shoot:
		return
	if ammo_in_mag <= 0:
		return
	
	state = WeaponState.SHOOTING
	
	ammo_in_mag -= 1
	fire_bullet()
	emit_signal("weapon_fired")
	start_cooldown()


func fire_bullet():
	if bullet_scene == null:
		push_error("Weapon: bullet_scene está null! Configure no Inspector.")
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = bullet_spawn_point.global_transform


func start_cooldown():
	can_shoot = false
	
	await get_tree().create_timer(shot_interval).timeout
	can_shoot = true
	
	# Se não está recarregando (ou interrompido), volta ao IDLE
	if state != WeaponState.RELOADING:
		state = WeaponState.IDLE


func reload():
	if state != WeaponState.IDLE:
		return
	if ammo_in_mag == mag_capacity:
		return
	if total_ammo <= 0:
		return
	
	state = WeaponState.RELOADING
	reload_cancelled = false
	emit_signal("weapon_reloaded")
	
	# Timer de animação/parcial do reload
	await get_tree().create_timer(0.4).timeout

	# Se foi interrompido por um tiro, abortar antes de mexer em munição
	if reload_cancelled:
		state = WeaponState.IDLE
		return

	# Completa o reload
	var needed = mag_capacity - ammo_in_mag
	var load_amount = min(needed, total_ammo)
	
	ammo_in_mag += load_amount
	total_ammo -= load_amount
	
	state = WeaponState.IDLE
