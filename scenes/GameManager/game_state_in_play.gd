class_name GameStateInPlay
extends GameState



func _ready() -> void:
	GameEvents.team_scored.connect(on_team_scored)

func _process(delta: float) -> void:
	GameManager.time_left -= delta
	if GameManager.time_left <= 0:
		transition_state(GameManager.State.OVERTIME)
	else:
		transition_state(GameManager.State.GAMEOVER)


func on_team_scored(country : String) -> void:
	transition_state(GameManager.State.SCORED, GameStateData.build().set_scored_country(country)) 
