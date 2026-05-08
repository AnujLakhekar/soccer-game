class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOT}
 
var velocity = Vector2.ZERO

var carrier : Player = null
var factory = BallStateFactory.new()
var current_state : BallState = null

@onready var player_detection_area: Area2D = %playerDetectionArea
@onready var animation: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	switch_state(State.FREEFORM)

func switch_state(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = factory.get_fresh_state(state)
	current_state.setup(self, player_detection_area, carrier, animation)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMacine"
	call_deferred("add_child", current_state)
