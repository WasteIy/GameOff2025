extends VBoxContainer

@onready var resolutions: OptionButton = $Resolutions
@onready var sensibility_x_slider: HSlider = $SensibilityContainer/SensibilityXContainer/SensibilityXSlider
@onready var sensibility_y_slider: HSlider = $SensibilityContainer/SensibilityYContainer/SensibilityYSlider
@onready var fov_slider: HSlider = $FOVContainer/FOVSlider

@onready var volume_value: Label = $VolumeContainers/VolumeContainer/VolumeValue
@onready var sensibility_x_value: Label = $SensibilityContainer/SensibilityXContainer/SensibilityXValue
@onready var sensibility_y_value: Label = $SensibilityContainer/SensibilityYContainer/SensibilityYValue
@onready var fov_value: Label = $FOVContainer/FOVValue


var settings_toggle = false
static var resolutionsAux = {
	"Normal": Vector2i(1152, 648),
	"Full HD": Vector2i(1920, 1080),
	"HD": Vector2i(1600, 900),
	"Test": Vector2i(1100, 680),
	"Mid": Vector2i(800, 450)
}

func _ready() -> void:
	# Configurações de resolução
	for chave in resolutionsAux:
		resolutions.add_item(chave)
	resolutions.select(0)
	
	# Configurar sliders de sensibilidade
	sensibility_x_slider.value = GameController.mouse_sensibility_x
	sensibility_y_slider.value = GameController.mouse_sensibility_y
	fov_slider.value = GameController.fov

func _on_resolutions_item_selected(index: int) -> void:
	var aux: Vector2i = resolutionsAux.get(resolutions.get_item_text(index))
	DisplayServer.window_set_size(aux)
	DisplayServer.window_set_position(Vector2i(0, 0))

func _on_mute_toggled(toggled_on: bool) -> void:
	GameController.master_volume_muted = toggled_on

func _on_volume_slider_value_changed(value: float) -> void:
	GameController.master_volume = value
	volume_value.set_text(str(value))

func _on_fov_slider_value_changed(value: float) -> void:
	GameController.fov = value
	fov_value.set_text(str(value))

func _on_sensibility_y_slider_value_changed(value: float) -> void:
	GameController.mouse_sensibility_y = value
	sensibility_y_value.set_text(str(value))

func _on_sensibility_x_slider_value_changed(value: float) -> void:
	GameController.mouse_sensibility_x = value
	sensibility_x_value.set_text(str(value))
