extends Control
@onready var settings_container: VBoxContainer = $SettingsContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/test_level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	settings_container.show()
	v_box_container.hide()


func _on_back_pressed() -> void:
	settings_container.hide()
	v_box_container.show()
