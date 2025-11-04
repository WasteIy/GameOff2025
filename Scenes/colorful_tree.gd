extends ColorfulEntity
class_name ColorfulObject


func _on_color_changed(active_color: GameManager.ColorEnum) -> void:
	var is_active = (color == active_color)
	_update_recursive(self, is_active)


func _update_recursive(node: Node, visible_state: bool) -> void:
	node.visible = visible_state

	if node.has_method("set_collision_layer") and node.has_method("set_collision_mask"):
		if visible_state:
			node.collision_layer = 1
			node.collision_mask = 1
		else:
			node.collision_layer = 0
			node.collision_mask = 0

	for child in node.get_children():
		_update_recursive(child, visible_state)
