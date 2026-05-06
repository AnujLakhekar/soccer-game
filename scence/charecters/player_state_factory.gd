class_name PlayerStateFactory


var states :Dictionary


func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLE: PlayerStateTackle
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State dosent exist")
	return states.get(state).new()
