class_name Player extends CharacterBody3D

@export var base_collision_height: float = 1.9
@export var base_model_height: float = 1.0
@export var height_change_duration: float = 0.15

@export_group("Movement Variables")
@export var max_speed : float = 50.0
@export var bunny_hop_desired_move_speed_increase : float = 3.0
@export var desired_move_speed_curve : Curve
@export var in_air_move_speed_curve : Curve
var move_speed : float
var move_acceleration : float 
var move_deceleration : float
var desired_move_speed : float = 0.0
var was_on_floor : bool
var last_frame_position : Vector3 
var last_frame_velocity : Vector3

@export_group("Walk variables")
@export var walk_speed : float = 9.0
@export var walk_acceleration : float = 11.0
@export var walk_deceleration : float = 10.0

@export_group("Run variables")
@export var run_speed : float = 12.0
@export var run_acceleration : float = 10.0
@export var run_deceleration : float = 9.0
@export var continuous_run : bool = false

@export_group("Crouch Variables")
@export var crouch_speed : float = 6.0
@export var crouch_acceleration : float = 12.0
@export var crouch_deceleration : float = 11.0
@export var continuous_crouch : bool = false
@export var crouch_collision_height : float = 1.25
@export var crouch_model_height: float = 0.75

@export_group("Slide Variables")
@export var slide_speed : float = 12.0
@export var slide_acceleration : float = 23.0
@export var velocity_lost_per_second : float = 4.0
@export var slope_sliding_desired_move_speed_increase : float = 2.0
@export var slope_sliding_speed_increase : float = 2.0
@export var slide_time : float = 1.2
@export var slide_cooldown : float = 1.2
@export var slide_collision_height : float = 1.25
@export var slide_model_height : float = 0.75
@export var continuous_slide : bool = true
@export_range(0.0, 90.0, 0.1) var max_slope_angle: float = 75.0 # Ângulo máximo pra se ter um slide
@export_range(0.0, 0.1, 0.001) var uphill_tolerance : float = 0.05 # Tolerância vertical
var slide_time_reference : float
var slide_cooldown_reference : float
var slide_buffering_on : bool = false
var slide_direction: Vector3 = Vector3.ZERO

@export_group("Jump Variables")
@export var jump_height: float = 2.1
@export var number_air_jump : int = 1
@export var coyote_jump_cooldown : float = 0.3
@export var in_air_input_multiplier : float = 1
@export var jump_time_to_peak : float = 0.34
@export var jump_time_to_fall : float = 0.28
@export var hit_ground_cooldown : float = 0.2 # Quantidade de tempo que se mantém a velocidade acumulada antes de perder ela
@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
var number_air_jump_reference: int
var buffered_jump_on : bool
var buffered_jump : bool
var coyote_jump_cooldown_reference : float
var coyote_jump_on : bool
var hit_ground_cooldown_reference : float

@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)

@onready var model: MeshInstance3D = $Model
@onready var camera_controller: CameraController = $CameraController
@onready var state_machine: StateMachine = $StateMachine
@onready var collision: CollisionShape3D = $Collision
@onready var floor_check: RayCast3D = $Raycasts/FloorCheck
@onready var ceiling_check: RayCast3D = $Raycasts/CeilingCheck
@onready var debug: CanvasLayer = $Debug
@onready var slide_floor_check: RayCast3D = $Raycasts/SlideFloorCheck
@onready var animation_manager: AnimationPlayer = $AnimationManager

var input_direction : Vector2
var move_direction : Vector3
var walk_or_run : String = "WalkState"
# Aqui vai colocar na memória se o personagem estava correndo ou andando antes de pular
# Nota que começa com WalkState, isso é pra fazer a transição do idle pro walk no primeiro input do jogador

func _ready():
	move_speed = walk_speed
	move_acceleration = walk_acceleration
	move_deceleration = walk_deceleration
	
	hit_ground_cooldown_reference = hit_ground_cooldown
	number_air_jump_reference = number_air_jump
	coyote_jump_cooldown_reference = coyote_jump_cooldown
	slide_time_reference = slide_time
	slide_cooldown_reference = slide_cooldown
	slide_cooldown = -1.0

func _physics_process(delta: float) -> void:
	update_properties()
	move_and_slide()
	
	if slide_cooldown > 0.0: 
		slide_cooldown -= delta
	else:
		if state_machine.current_state.name != "SlideState":
			slide_time = slide_time_reference

func apply_gravity(delta: float):
	if not is_on_floor():
		if velocity.y >= 0.0:
			velocity.y += jump_gravity * delta
		else:
			velocity.y += fall_gravity * delta
	else:
		velocity.y = 0.0

func update_properties():
	last_frame_position = position
	last_frame_velocity = velocity
	was_on_floor = !is_on_floor()

func tween_collision_height(state_collision_height : float) -> void:
	var collision_tween: Tween = create_tween()
	if collision != null:
		collision_tween.tween_method(func(v): set_collision_height(v), collision.shape.height, 
		state_collision_height, height_change_duration)
	# Evitar o erro de não ter tweeners
	else:
		collision_tween.tween_interval(0.1)
	collision_tween.finished.connect(Callable(collision_tween, "kill"))

func set_collision_height(value: float) -> void:
	if collision.shape is CapsuleShape3D:
		collision.shape.height = value

func tween_model_height(state_model_height : float) -> void:
	var model_tween: Tween = create_tween()
	if model != null:
		model_tween.tween_property(model, "scale:y", 
		state_model_height, height_change_duration)
	# Evitar o erro de não ter tweeners
	else:
		model_tween.tween_interval(0.1)
	model_tween.finished.connect(Callable(model_tween, "kill"))
