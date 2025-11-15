class_name Weapon extends Node3D

signal weapon_fired
signal weapon_reloaded

@export var fire_rate : float = 0.2
@export var ammo_in_mag : int = 10
@export var mag_capacity : int = 10
@export var total_ammo : int = 30

@export var bullet_scene : PackedScene

@onready var bullet_spawn_point : Marker3D = $BulletSpawnPoint

var active : bool

var can_fire : bool = true
var is_reloading : bool = false
var manager : Node = null

func shoot():
	weapon_fired.emit()

func reload():
	weapon_reloaded.emit()
