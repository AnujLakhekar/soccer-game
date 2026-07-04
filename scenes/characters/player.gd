class_name Player
extends CharacterBody2D

const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}
const GRAVITY := 8.0

enum ControlScheme {CPU, P1, P2}
enum Role {GOALTE, DEFENSE, OFFENSE, MIDFIELD}
enum SkinColor {LIGHT, MID, DARK}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL}

@export var ball : Ball
@export var control_scheme : ControlScheme
@export var own_goal : Goal
@export var power : float
@export var speed : float
@export var target_goal : Goal

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var ball_detection_area : Area2D = %BallDetectionArea
@onready var control_sprite : Sprite2D = %ControlSprite
@onready var player_sprite : Sprite2D = %PlayerSprite
@onready var teammate_detection_area : Area2D = %TeammateDetectionArea

var current_state: PlayerState = null
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var state_factory := PlayerStateFactory.new()
var role  = Player.Role.MIDFIELD
var skincolor = Player.SkinColor.MID
var fullname : String 

func _ready() -> void:
	set_control_texture()
	switch_state(State.MOVING)

func _process(delta: float) -> void:
	flip_sprites()
	set_sprite_visibility()
	process_gravity(delta)
	move_and_slide()

func initialize(player_pos : Vector2, c_ball : Ball, c_own_goal : Goal , c_taget_goal : Goal, player_data : PlayerResource) -> void:
	position = player_pos
	ball = c_ball
	own_goal = c_own_goal
	target_goal = c_taget_goal
	speed = player_data.speed
	power = player_data.power
	role = player_data.role
	skincolor = player_data.skin_color
	fullname = player_data.full_name
	heading = Vector2.LEFT if c_taget_goal.position.x < position.x else Vector2.RIGHT

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data, animation_player, ball, teammate_detection_area, ball_detection_area, target_goal, own_goal)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height <= 0:
			height = 0
	player_sprite.position = Vector2.UP * height

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT

func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true

func set_sprite_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

func has_ball() -> bool:
	return ball.carrier == self

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
func control_ball() -> void:
	if ball.height > 10.0:
		switch_state(State.CHEST_CONTROL)
