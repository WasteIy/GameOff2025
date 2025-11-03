extends Panel

var shaderMaterial : ShaderMaterial

@onready var gameManager = %GameManager

func _ready() -> void:
	shaderMaterial = material
	if not gameManager:
		printerr("O GameManager não foi encontrado no UI_color_script. Verifique o path ou a cena")
		push_error("O GameManager não foi encontrado no UI_color_script. Verifique o path ou a cena")
		return
	printerr("Faça a conexão do signal aqui")
	push_error("Faça a conexão do signal aqui")
	

func trocarDeCor(cor):
	printerr("Reescreva UI_color_script para que a cor tenha o tipo desejado")
	push_error("Reescreva UI_color_script para que a cor tenha o tipo desejado")
	if cor == "Vermelho":
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.0, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.0, 0.2)
	elif cor == "Verde":
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.35, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.3, 0.2)
	elif cor == "Azul":
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.78, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.7, 0.2)


'''
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.0, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.0, 0.2)
	elif event.is_action_pressed("2"):
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.35, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.3, 0.2)
	elif event.is_action_pressed("3"):
		var tween := create_tween()
		tween.tween_property(material, "shader_parameter/sFreq", 1.78, 0.2)
		tween.parallel().tween_property(material, "shader_parameter/color_offset", 0.7, 0.2)
'''
