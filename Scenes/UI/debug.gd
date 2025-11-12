extends CanvasLayer

@export var player : CharacterBody3D

@onready var velocity_label: Label = %VelocityLabel
@onready var coyote_cooldown_label: Label = %CoyoteCooldownLabel
@onready var max_speed_label: Label = %MaxSpeedLabel
@onready var desired_move_speed_label: Label = %DesiredMoveSpeedLabel
@onready var coyote_jump_on_label: Label = %CoyoteJumpOnLabel

@onready var air_jumps_left_label: Label = %AirJumpsLeftLabel
@onready var hit_ground_cooldown_label: Label = %HitGroundCooldownLabel
@onready var jump_velocity_label: Label = %JumpVelocityLabel
@onready var buffered_jump_label: Label = %BufferedJumpLabel
@onready var jump_gravity_label: Label = %JumpGravityLabel
@onready var fall_gravity_label: Label = %FallGravityLabel

@onready var last_frame_position_label: Label = %LastFramePositionLabel
@onready var last_frame_velocity_label: Label = %LastFrameVelocityLabel

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
	velocity_label.set_text("%.2f" % player.velocity.length())
	coyote_cooldown_label.set_text("%.2f" % player.coyote_jump_cooldown)
	max_speed_label.set_text("%.2f" % player.max_speed)
	desired_move_speed_label.set_text("%.2f" % player.desired_move_speed)
	coyote_jump_on_label.set_text(str(player.coyote_jump_on))
	
	air_jumps_left_label.set_text(str(player.number_air_jump)) #?
	hit_ground_cooldown_label.set_text("%.2f" % player.hit_ground_cooldown) 
	jump_velocity_label.set_text("%.2f" % player.jump_velocity)
	buffered_jump_label.set_text(str(player.buffered_jump))
	jump_gravity_label.set_text("%.2f" % player.jump_gravity)
	fall_gravity_label.set_text("%.2f" % player.fall_gravity)
	
	last_frame_position_label.set_text("X:%.2f Y:%.2f Z:%.2f" % [player.last_frame_position.x, player.last_frame_position.y, player.last_frame_position.z])
	last_frame_velocity_label.set_text("%.2f" % player.last_frame_velocity.length())
