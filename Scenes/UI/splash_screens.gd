extends Control

@export var loadScene : PackedScene
var in_time : float = 0.5
var fade_in_time : float = 1.5
var pause_time : float = 1.5
var fade_out_time : float = 1.5
var out_time : float = 0.5

@onready var center_container: CenterContainer = $CenterContainer

var splash_screens : Array

func get_screens() -> void:
	splash_screens = center_container.get_children()
	for screen in splash_screens:
		screen.modulate.a = 0.0

func fade() -> void:
	for screen in splash_screens:
		var tween = self.create_tween()
		tween.tween_interval(in_time)
		tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		tween.tween_interval(pause_time)
		tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		tween.tween_interval(out_time)
		await tween.finished
	get_tree().change_scene_to_packed(loadScene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_screens()
	fade()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_tree().change_scene_to_packed(loadScene)
