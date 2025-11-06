class_name Player extends CharacterBody3D

@export_group("Movement Variables")
@export var move_speed : float = 10.0
@export var max_speed : float = 15.0
@export var jump_velocity: float = 4.5
# Quantidade de tempo que se mantém a velocidade acumulada antes de perder ela
@export var hit_ground_cooldown : float = 1

@export var move_acceleration : float = 10.0
@export var move_deceleration : float = 10.0

@onready var camera_holder: CameraHolder = $CameraHolder
@onready var state_machine: StateMachine = $StateMachine

var desired_move_speed : float = 0.0

var input_direction : Vector2
var move_direction : Vector3
var walk_or_run : String = "WalkState"
# Aqui vai colocar na memória se o personagem estava correndo ou andando antes de pular
# Nota que começa com WalkState, isso é pra fazer a transição do idle pro walk no primeiro input do jogador

func _physics_process(_delta: float) -> void:
	move_and_slide()
