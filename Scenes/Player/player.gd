class_name Player extends CharacterBody3D

@export_group("Movement Variables")
@export var move_speed : float = 10.0
@export var max_speed : float = 15.0
@export var move_acceleration : float = 10.0
@export var move_deceleration : float = 10.0
@export var bunny_hop_desired_move_speed_increase : float = 1.0
@export var desired_move_speed_curve : Curve
@export var in_air_move_speed_curve : Curve
var desired_move_speed : float = 0.0


@export_group("Jump Variables")
@export var jump_height: float = 4.5
@export var jump_cooldown: float = 0.5
@export var number_air_jump : int = 1
@export var coyote_jump_cooldown : float = 0.2
@export var in_air_input_multiplier : float = 0.8
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_fall : float = 0.35
@export var hit_ground_cooldown : float = 1.0 # Quantidade de tempo que se mantém a velocidade acumulada antes de perder ela
@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
var jump_cooldown_reference : float
var number_air_jump_reference: int
var buffered_jump : bool
var coyote_jump_cooldown_reference : float
var coyote_jump_on : bool
var hit_ground_cooldown_reference : float

@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)

@onready var camera_holder: CameraHolder = $CameraHolder
@onready var state_machine: StateMachine = $StateMachine
@onready var collision: CollisionShape3D = $Collision
@onready var model: MeshInstance3D = $Model

var input_direction : Vector2
var move_direction : Vector3
var walk_or_run : String = "WalkState"
# Aqui vai colocar na memória se o personagem estava correndo ou andando antes de pular
# Nota que começa com WalkState, isso é pra fazer a transição do idle pro walk no primeiro input do jogador

func _ready():
	# Passar a referência das variáveis
	
	hit_ground_cooldown_reference = hit_ground_cooldown
	jump_cooldown_reference = jump_cooldown
	number_air_jump_reference = number_air_jump
	coyote_jump_cooldown_reference = jump_cooldown_reference

func _physics_process(_delta: float) -> void:
	move_and_slide()
func apply_gravity(delta : float):
	# Se o personagem vai pra cima, aplica a jump_velocity
	# Se não, a fall-velocityw
	if velocity.y >= 0.0: velocity.y += jump_gravity * delta
	elif velocity.y < 0.0: velocity.y += fall_gravity * delta
