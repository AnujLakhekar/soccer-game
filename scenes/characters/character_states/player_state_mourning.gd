class_name PlayerStateMouring
extends PlayerState


func _enter_tree() -> void:
	animation_player.play("mourn")
	player.velocity = Vector2.ZERO
	GameEvents.team_reset.connect(on_team_reset)


func on_team_reset() -> void:
	transition_state(Player.State.RESETING, PlayerStateData.build().set_reset_position(player.kickofposition))
