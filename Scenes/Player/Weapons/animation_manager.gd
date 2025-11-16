extends AnimationPlayer

func _on_weapon_fired() -> void:
	if current_animation == "shoot":
		return
	play("shoot")

func _on_weapon_reloaded() -> void:
	play("reload")
