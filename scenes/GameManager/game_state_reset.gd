class_name GameStateReset
extends GameState

var players : Array = []

func  _enter_tree() -> void:
	GameEvents.team_reset.emit()
	GameEvents.kick_off.connect(on_game_kickof_ready)


func on_game_kickof_ready() -> void:
	transition_state(GameManager.State.KICKOFF)
