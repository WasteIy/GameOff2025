extends Control

@onready var settings: Control = $Settings
@onready var resolutions: OptionButton = $Settings/Resolutions
@onready var pause_menu_container: VBoxContainer = $VBoxContainer

var pause_toggle = false


func _ready() -> void:
	self.visible = false
	settings.visible = false

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

func _on_back_pressed() -> void:
	$Settings.hide()
	pause_menu_container.show()
