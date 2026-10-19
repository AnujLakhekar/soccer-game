class_name GameStateScored
extends GameState


const CELEBRETION_DURATION = 3000
var time_scence_celebration = Time.get_ticks_msec()

func _enter_tree() -> void:
	print("goal")
	var index = 0 if state_data.scored_country == GameManager.countries[0] else 1
	GameManager.score[index] += 1
	time_scence_celebration = Time.get_ticks_msec()


func _process(delta: float) -> void:
	if Time.get_ticks_msec()  - time_scence_celebration > CELEBRETION_DURATION:
		transition_state(GameManager.State.RESET)
	
