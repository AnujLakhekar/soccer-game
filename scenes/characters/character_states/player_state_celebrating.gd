class_name PlayerStateCelebrate
extends PlayerState

const AIR_FRICTION = 35.0

func _enter_tree() -> void:
	celibrate()
	GameEvents.team_reset.connect(on_team_reset)


func on_team_reset() -> void:
	transition_state(Player.State.RESETING, PlayerStateData.build().set_reset_position(player.spawn_point))


func celibrate() -> void:
	animation_player.play("celebrate")
	player.height = 0.1
	player.height_velocity = 2.0

func _process(delta: float) -> void:
	if player.height == 0:
		celibrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
