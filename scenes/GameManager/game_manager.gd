extends Node

const DURATION_GAME_SEC = 1 #2 * 60 

enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER}

var current_state : GameState = null
var state_factory : GameStateFactory = GameStateFactory.new()
var time_left : float
var countries : Array[String] = ["FRANCE", "USA"]
var score : Array[int] = [0, 0]

func _ready() -> void:
	time_left = DURATION_GAME_SEC
	switch_state(State.IN_PLAY)

func switch_state(state : State, data : GameStateData = GameStateData.build()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_state(state)
	current_state.setup(data)
	current_state.state_transition_signal.connect(switch_state)
	current_state.name = "GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)
