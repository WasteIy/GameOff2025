extends AnimationPlayer



func _on_shoot_animation() -> void:
	if current_animation == "Shoot":
		return
	play("Shoot")

func _on_reload_animation() -> void:
	play("Reload")
