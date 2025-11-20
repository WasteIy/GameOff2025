extends AnimationPlayer



func _on_shoot_animation() -> void:
	if current_animation == "shoot":
		return
	play("shoot")

func _on_reload_animation() -> void:
	play("reload")
