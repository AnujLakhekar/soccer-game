class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOT}
 
var velocity = Vector2.ZERO

var carrier : Player = null
var factory = BallStateFactory.new()
var current_state : BallState = null

var height = 0.0

@onready var player_detection_area: Area2D = %playerDetectionArea
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D

func _ready() -> void:
	switch_state(State.FREEFORM)
	
func _process(delta: float) -> void:
	sprite.position = Vector2.UP * height

func switch_state(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = factory.get_fresh_state(state)
	current_state.setup(self, player_detection_area, carrier, animation, sprite)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMacine"
	call_deferred("add_child", current_state)


func shoot(velocity_of_ball: Vector2) -> void:
	velocity = velocity_of_ball
	carrier = null
	switch_state(Ball.State.SHOT)
	
