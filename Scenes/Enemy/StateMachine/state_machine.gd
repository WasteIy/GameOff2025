extends Node
var current_state: State
var states: Dictionary[String, State] = {}
@export var enemy_node: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
	print(states)
	if states["idlestate"]:
		states["idlestate"].enter(enemy_node)
		current_state=states["idlestate"]

# A gente precisa transferir os process desse script pro estado atual
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_state_transitioned(state: State, new_state_name: String) -> void:
	# Só processa se o sinal veio do estado atual
	if state != current_state:
		return

	var new_state: State = states.get(new_state_name.to_lower())
	assert(new_state, "State not found: " + new_state_name)

	if current_state:
		current_state.exit()

	new_state.enter(enemy_node)
	current_state = new_state


func getRotationSpeedX() -> float:
	var parent: Node3D = get_parent()
	return parent.rotation_speed_x
