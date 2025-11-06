class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State] = {}

@onready var player: Player = $".."

# Aqui adiciona todos os filhos desse nó no dictionary
func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
	
	# Se acostuma com isso, a gente sempre tem que conferir se existe
	# um estado atual ou inicial antes de rodar o código, pro jogo não crashar
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# A gente precisa transferir os process desse script pro estado atual
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	# Esse to_lower() é pra evitar problema envolvendo capitalização
	
	# Assert pega a primeira variável, se ela for true, tudo bem, se for false, dá erro
	assert(new_state, "State not found: " + new_state_name)
	# Ou seja, se new_state é falso, significa que a gente chamou um state que não existe
	
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	current_state = new_state
