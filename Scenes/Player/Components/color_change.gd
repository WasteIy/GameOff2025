extends Node

@export var COLOR_CHANGE_COOLDOWN := 0.1  

var can_change_color := true

func _input(event: InputEvent) -> void:
	if not can_change_color:
		return

	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				_change_color(1)
			MOUSE_BUTTON_WHEEL_DOWN:
				_change_color(-1)


func _change_color(direction: int) -> void:
	GameManager.cycle_color(direction)
	can_change_color = false
	_start_cooldown()


func _start_cooldown() -> void:
	await get_tree().create_timer(COLOR_CHANGE_COOLDOWN).timeout
	can_change_color = true
