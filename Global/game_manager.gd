extends Node

signal color_changed(new_color)

enum ColorEnum { RED, GREEN, BLUE }

var active_color : ColorEnum = ColorEnum.RED

func set_color(new_color: ColorEnum) -> void:
	if new_color != active_color:
		active_color = new_color
		emit_signal("color_changed", new_color)


func cycle_color(increment) -> void:
	var next_color = int(active_color) + increment
	
	if next_color < ColorEnum.RED:
		next_color = ColorEnum.BLUE
	elif next_color > ColorEnum.BLUE:
		next_color = ColorEnum.RED
	set_color(next_color)
