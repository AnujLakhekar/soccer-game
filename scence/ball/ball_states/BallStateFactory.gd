class_name BallStateFactory

var states : Dictionary


func _init() -> void:
	states = {
		Ball.State.CARRIED : BallStateCarried,
		Ball.State.FREEFORM : BallStateFreeFrom,
		Ball.State.SHOT: BallStateShot
	}


func get_fresh_state(state: Ball.State) -> BallState:
	assert(states.has(state), "state dont exists")
	return states.get(state).new()
