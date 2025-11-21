extends CanvasLayer

@export var player : CharacterBody3D
@onready var weapon_manager: WeaponManager = $"../CameraController/Camera/WeaponManager"

@onready var animation_speed_label: Label = %AnimationSpeedLabel

@onready var current_state_label: Label = %CurrentStateLabel
@onready var velocity_label: Label = %VelocityLabel
@onready var max_speed_label: Label = %MaxSpeedLabel
@onready var desired_move_speed_label: Label = %DesiredMoveSpeedLabel

@onready var air_jumps_left_label: Label = %AirJumpsLeftLabel
@onready var hit_ground_cooldown_label: Label = %HitGroundCooldownLabel
@onready var jump_velocity_label: Label = %JumpVelocityLabel
@onready var buffered_jump_on_label: Label = %BufferedJumpOnLabel
@onready var jump_gravity_label: Label = %JumpGravityLabel
@onready var fall_gravity_label: Label = %FallGravityLabel
@onready var coyote_cooldown_label: Label = %CoyoteCooldownLabel

@onready var last_frame_position_label: Label = %LastFramePositionLabel
@onready var last_frame_velocity_label: Label = %LastFrameVelocityLabel

@onready var slide_cooldown_label: Label = %SlideCooldownLabel
@onready var slide_time_label: Label = %SlideTimeLabel
@onready var slide_buffering_on_label: Label = %SlideBufferingOnLabel
@onready var floor_check_label: Label = %FloorCheckLabel
@onready var ceiling_check_label: Label = %CeilingCheckLabel
@onready var slide_floor_check_label: Label = %SlideFloorCheckLabel

@onready var weapon_state_label: Label = %WeaponStateLabel
@onready var weapon_ammo_label: Label = %WeaponAmmoLabel
@onready var shoot_cooldown_label: Label = %ShootCooldownLabel
@onready var reload_duration_label: Label = %ReloadDurationLabel
@onready var reload_canceled_label: Label = %ReloadCanceledLabel

# Visible toggle
var debug_visible: bool = false

func _ready():
	visible = debug_visible

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		debug_visible = !debug_visible
		visible = debug_visible
	
	if debug_visible:
		display()

func display():
	current_state_label.set_text(player.state_machine.current_state.name)
	
	velocity_label.set_text("%.2f" % player.velocity.length())
	max_speed_label.set_text("%.2f" % player.max_speed)
	desired_move_speed_label.set_text("%.2f" % player.desired_move_speed)
	
	animation_speed_label.set_text("%.2f" % player.animation_manager.speed_scale)
	
	air_jumps_left_label.set_text(str(player.number_air_jump)) #?
	hit_ground_cooldown_label.set_text("%.2f" % player.hit_ground_cooldown) 
	jump_velocity_label.set_text("%.2f" % player.jump_velocity)
	buffered_jump_on_label.set_text(str(player.buffered_jump_on))
	jump_gravity_label.set_text("%.2f" % player.jump_gravity)
	fall_gravity_label.set_text("%.2f" % player.fall_gravity)
	coyote_cooldown_label.set_text("%.2f" % player.coyote_jump_cooldown)
	
	last_frame_position_label.set_text("X:%.2f Y:%.2f Z:%.2f" % [player.last_frame_position.x, player.last_frame_position.y, player.last_frame_position.z])
	last_frame_velocity_label.set_text("%.2f" % player.last_frame_velocity.length())
	
	slide_cooldown_label.set_text("%.2f" % player.slide_cooldown)
	slide_time_label.set_text("%.2f" % player.slide_time)
	slide_buffering_on_label.set_text(str(player.slide_buffering_on))
	floor_check_label.set_text(str(player.floor_check.is_colliding()))
	ceiling_check_label.set_text(str(player.ceiling_check.is_colliding()))
	slide_floor_check_label.set_text(str(player.slide_floor_check.is_colliding()))
	
	weapon_ammo_label.set_text(str(weapon_manager.current_weapon.ammo_in_mag))
	
	match weapon_manager.state:
		0:
			weapon_state_label.set_text("IDLE")
		1:
			weapon_state_label.set_text("SHOOTING")
		2:
			weapon_state_label.set_text("RELOADING")
	
	shoot_cooldown_label.set_text("%.2f" % weapon_manager.shoot_cooldown)
	reload_duration_label.set_text("%.2f" % weapon_manager.reload_cooldown)
	reload_canceled_label.set_text(str(weapon_manager.reload_canceled))
