extends Panel

var shaderMaterial : ShaderMaterial

var gameManager : GameManager = GameManager
var old_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	shaderMaterial = material
	
	if not gameManager:
		printerr("O GameManager não foi encontrado.")
		push_error("O GameManager não foi encontrado.")
		return
	if not gameManager.is_connected("color_changed", Callable(self, "change_color")):
		gameManager.connect("color_changed", Callable(self, "change_color"))


func change_color(_cor : int):
	if old_tween:
		old_tween.stop()
	print("Cheguei aqui")
	visible = true
	old_tween = create_tween()
	old_tween.set_parallel(false)
	old_tween.tween_property(shaderMaterial, "shader_parameter/shake_color_rate", 0.02, 0.1)
	old_tween.tween_property(shaderMaterial, "shader_parameter/shake_color_rate", 0.0, 0.1)
	await old_tween.finished
	visible = false
