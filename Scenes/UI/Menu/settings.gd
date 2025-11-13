extends Control

@onready var resolutions: OptionButton = $MarginContainer/Resolutions


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_volume_db(0,toggled_on)


func _on_resolutions_item_selected(index: int) -> void:
	var resolution: String = resolutions.get_item_text(index)
	var h_resolution: int = int(resolution.get_slice("x", 0))
	var v_resolution: int = int(resolution.get_slice("x", 1))
	DisplayServer.window_set_size(Vector2i(h_resolution, v_resolution))
			
