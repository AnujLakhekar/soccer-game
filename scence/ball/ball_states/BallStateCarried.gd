class_name BallStateCarried
extends BallState

const OFFESET_FROM_PLAYER = Vector2(10, 4)
var dcribble_time = 0.0
var dribble_intencity  = 10
var dribble_frq = 5


func _enter_tree() -> void:
	assert(carrier != null)



func _process(delta: float) -> void:
	var vx = 0.0
	dcribble_time += delta
	if carrier.velocity != Vector2.ZERO:
		if carrier.velocity.x != 0:
			vx = cos(dcribble_time * dribble_frq) * dribble_intencity
		if carrier.heading.x >=0:
			animation.play("roll")
			animation.advance(0)
		else:
			animation.play_backwards("roll")
			animation.advance(0)
	else:
		animation.play("idle")
	
	ball.position = carrier.position + Vector2(vx + carrier.heading.x * OFFESET_FROM_PLAYER.x, carrier.heading.y * OFFESET_FROM_PLAYER.y)
	
