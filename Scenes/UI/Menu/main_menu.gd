extends Control

@onready var settings: VBoxContainer = $Settings
@onready var v_box_container: VBoxContainer = $VBoxContainer
var volume_value = -20.0

func _ready() -> void:
	GameController.master_volume = -40  # Start Mute
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -40)
	
	# tween fade in volume
	var tween = create_tween()
	tween.tween_method(_update_volume, -40.0, volume_value, 2.0)

func _update_volume(value: float) -> void:
	GameController.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/debug_level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	settings.show()
	v_box_container.hide()


func _on_back_pressed() -> void:
	settings.hide()
	v_box_container.show()
