class_name GameStateInPlay
extends GameState

func _enter_tree() -> void:
	GameEvents.team_scored.connect(on_team_scored.bind())

func _process(delta: float) -> void:
	GameManager.time_left -= delta
	if GameManager.time_left <= 0:
		if GameManager.score[0] == GameManager.score[1]:
			transition_state(GameManager.State.OVERTIME)
		else:
			transition_state(GameManager.State.GAMEOVER)

func on_team_scored(country_scored_on: String) -> void:
	transition_state(GameManager.State.SCORED, GameStateData.build().set_scored_country(country_scored_on))
