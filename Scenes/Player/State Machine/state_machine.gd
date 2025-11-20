class_name StateMachine extends Node

@export var initial_state: State

@onready var player: Player = $".."

var current_state: State
var states: Dictionary[String, State] = {}

# Aqui adiciona todos os filhos desse nó no dictionary
func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
	
	# Se acostuma com isso, a gente sempre tem que conferir se existe
	# um estado atual ou inicial antes de rodar o código, pro jogo não crashar
	if initial_state:
		initial_state.enter(player)
		current_state = initial_state

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
	
	new_state.enter(player)
	current_state = new_state
	player.animation_manager.play_state_animation(current_state.name)
