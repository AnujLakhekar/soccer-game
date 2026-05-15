class_name PlayerStateFactory


var states :Dictionary


func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLE: PlayerStateTackle,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.SHOOTING : PlayerStateShoot,
		Player.State.PREPARING_SHOOT : PlayerStatePreparingShoot
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State dosent exist")
	return states.get(state).new()
