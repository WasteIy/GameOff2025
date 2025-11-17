extends VBoxContainer

@onready var resolutions: OptionButton = $Resolutions


var settings_toggle = false
static var resolutionsAux = {
	"Normal" : Vector2i(1152,648),
	"Full HD": Vector2i(1920, 1080),
	"HD" : Vector2i(1600, 900),
	"Test" : Vector2i(1100,680),
	"Mid" : Vector2i(800,450)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for chave in resolutionsAux:
		resolutions.add_item(chave)
	resolutions.select(0)


func _on_resolutions_item_selected(index: int) -> void:
	var aux: Vector2i = resolutionsAux.get(resolutions.get_item_text(index))
	DisplayServer.window_set_size(aux)
	DisplayServer.window_set_position(Vector2i(0,0))


func _on_mute_toggled(toggled_on: bool) -> void:
	GameController.master_volume = toggled_on


func _on_h_slider_value_changed(value: float) -> void:
	GameController.master_volume = value
