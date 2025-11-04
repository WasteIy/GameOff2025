extends ColorfulEntity
class_name ColorfulTree

func _set_active(active: bool) -> void:
	is_active = active 
	_update_recursive(self)

func _update_recursive(node: Node) -> void:
	node.visible = is_active

	if node.has_method("set_collision_layer") and node.has_method("set_collision_mask"):
		node.collision_layer = 1 if is_active else 0
		node.collision_mask = 1 if is_active else 0

	for child in node.get_children():
		_update_recursive(child)
