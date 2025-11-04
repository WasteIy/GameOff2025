extends Panel

var shaderMaterial : ShaderMaterial
var gameManager : GameManager = GameManager

func _ready() -> void:
	shaderMaterial = material
	
	if not gameManager:
		printerr("O GameManager não foi encontrado.")
		push_error("O GameManager não foi encontrado.")
		return
	
	if not gameManager.is_connected("color_changed", Callable(self, "change_color")):
		gameManager.connect("color_changed", Callable(self, "change_color"))
	change_color(gameManager.active_color)


func change_color(cor: int) -> void:
	var tween := create_tween()
	match cor:
		GameController.ColorEnum.RED:
			tween.tween_property(material, "shader_parameter/sFreq", 1.0, 0.2)
			tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.0, 0.2)
		GameController.ColorEnum.GREEN:
			tween.tween_property(material, "shader_parameter/sFreq", 1.5, 0.2)
			tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.3, 0.2)
		GameController.ColorEnum.BLUE:
			tween.tween_property(material, "shader_parameter/sFreq", 2.0, 0.2)
			tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.7, 0.2)
