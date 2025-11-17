extends Control

@onready var settings: Control = $Settings
@onready var resolutions: OptionButton = $Settings/Resolutions
@onready var pause_menu_container: VBoxContainer = $VBoxContainer

var pause_toggle = false
var settings_toggle = false
static var resolutionsAux = {
	"Normal" : Vector2i(1152,648),
	"Full HD": Vector2i(1920, 1080),
	"HD" : Vector2i(1600, 900),
	"Test" : Vector2i(1100,680),
	"Mid" : Vector2i(800,450)
}

func _ready() -> void:
	self.visible = false
	settings.visible = false
	for chave in resolutionsAux:
		resolutions.add_item(chave)
	resolutions.select(0)

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		pause_and_unpause()

func pause_and_unpause():
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	self.visible = pause_toggle
	
	if pause_toggle:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	pause_and_unpause()

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed() -> void:
	$Settings.show()
	pause_menu_container.hide()
	
func _on_h_slider_value_changed(value: float) -> void:
	GameController.master_volume = value

func _on_resolutions_item_selected(index: int) -> void:
	var aux: Vector2i = resolutionsAux.get(resolutions.get_item_text(index))
	DisplayServer.window_set_size(aux)
	DisplayServer.window_set_position(Vector2i(0,0))

func _on_mute_toggled(toggled_on: bool) -> void:
	GameController.master_volume = toggled_on

func _on_back_pressed() -> void:
	$Settings.hide()
	pause_menu_container.show()
