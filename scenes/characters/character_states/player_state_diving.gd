class_name PlayerStateDiving
extends PlayerState

const DURATION = 500
var time_scence = Time.get_ticks_msec()

func _enter_tree() -> void:
	var target_destination = Vector2(player.spawn_point.x, ball.position.y)
	var direction = player.position.direction_to(target_destination)
	
	if direction.y > 0:
		animation_player.play("dive_down")
	else:
		animation_player.play("dive_up")
		
	player.velocity = direction * player.speed
	time_scence = Time.get_ticks_msec()


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_scence > DURATION:
		transition_state(Player.State.RECOVERING)
