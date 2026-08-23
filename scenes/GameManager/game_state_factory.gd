class_name GameStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		GameManager.State.IN_PLAY : GameStateInPlay,
		GameManager.State.OVERTIME : GameStateOvertime,
		GameManager.State.GAMEOVER : GameStateGameOver,
		GameManager.State.SCORED : GameStateScored,
		GameManager.State.RESET  : GameStateReset
	}


func get_state(state : GameManager.State) -> GameState:
	assert(states.has(state), "the game state not exits")
	return states.get(state).new()
