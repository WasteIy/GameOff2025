extends AnimationPlayer


func _on_weapon_fired() -> void:
	if current_animation == "shoot":
		return
	play("shoot")


func _on_weapon_reloaded() -> void:
	play("reload")


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == "shoot":
		pass
	
	if animation_name == "reload":
		pass
