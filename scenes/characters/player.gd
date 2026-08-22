class_name Player
extends CharacterBody2D

const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}
const GRAVITY := 8.0
const COUNTRIES := ["DEFAULT", "FRANCE", "ARGENTINA", "BRAZIL", "ENGLAND", "GERMANY", "ITALY", "SPAIN", "USA"]
enum ControlScheme {CPU, P1, P2}
enum Role {GOALTE, DEFENSE, OFFENSE, MIDFIELD}
enum SkinColor {LIGHT, MID, DARK}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL, HURT, DIVING}

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
@onready var takel_damange_emmiter: Area2D = $TakelDamangeEmmiter
@onready var oppnent_detection_area: Area2D = $OppnentDetectionArea
@onready var permenent_damage_emitter: Area2D = %PermenentDamageEmitter
@onready var goalhands: AnimatableBody2D = $goalhands
@onready var gaoli_hands_colider: CollisionShape2D = %GaoliHandsColider

var country = ""
var current_state: PlayerState = null
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var state_factory := PlayerStateFactory.new()
var role  = Player.Role.MIDFIELD
var skincolor = Player.SkinColor.MID
var fullname : String 

var walk_thresohld = 0.6

# ai behaviors 
var aibehaviorfactory : AIBehaviorFactory = AIBehaviorFactory.new()
var current_ai_behavior : AIbehavior = null
var spawn_point = Vector2.ZERO
var weight_on_duty_sterrring = 0.0

func _ready() -> void:
	set_shaders()
	set_control_texture()
	setup_ai_behavior()
	switch_state(State.MOVING)
	
	# player behavior 
	gaoli_hands_colider.disabled = role != Role.GOALTE
	permenent_damage_emitter.monitoring = role == Role.GOALTE
	gaoli_hands_colider.disabled = role == Role.GOALTE
	takel_damange_emmiter.body_entered.connect(takle_on_body_enter)
	permenent_damage_emitter.body_entered.connect(takle_on_body_enter)
	spawn_point = position

func set_shaders() -> void:
	player_sprite.material.set_shader_parameter("skin_color", skincolor)
	var country_code = COUNTRIES.find(country)
	country_code = clampi(country_code, 0, COUNTRIES.size() - 1 )
	player_sprite.material.set_shader_parameter("team_color", country_code)

func _process(delta: float) -> void:
	flip_sprites()
	set_sprite_visibility()
	process_gravity(delta)
	move_and_slide()

func initialize(player_pos : Vector2, c_ball : Ball, c_own_goal : Goal , c_taget_goal : Goal, player_data : PlayerResource, c_country : String) -> void:
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
	country = c_country

func setup_ai_behavior() -> void:
	current_ai_behavior = aibehaviorfactory.get_ai_behavior(role)
	current_ai_behavior.setup(ball, self, oppnent_detection_area)
	current_ai_behavior.name = "Ai behavior"
	add_child(current_ai_behavior)

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new(), ) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data, animation_player, ball, teammate_detection_area, ball_detection_area, target_goal, own_goal, takel_damange_emmiter, current_ai_behavior)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func set_movement_animation() -> void:
	var v_l = velocity.length()
	if v_l < 1:
		animation_player.play("idle")
	elif v_l < speed * walk_thresohld:
		animation_player.play("walk")
	else:
		animation_player.play("run")

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
		takel_damange_emmiter.scale.x = 1
		oppnent_detection_area.scale.x = 1
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true
		takel_damange_emmiter.scale.x = -1
		oppnent_detection_area.scale.x = -1
	
func takle_on_body_enter(player: Player) -> void:
	if player != self and player.country != country and player == ball.carrier:
		player.get_hurt(position.direction_to(player.position))

func set_sprite_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

func has_ball() -> bool:
	return ball.carrier == self

func get_hurt(origin: Vector2) -> void:
	var data = PlayerStateData.build().set_hurt_direction(origin)
	switch_state(Player.State.HURT, data)

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func control_ball() -> void:
	if ball.height > 10.0:
		switch_state(State.CHEST_CONTROL)

func can_carry_ball() -> bool:
	return current_state != null and current_state.can_carry_ball()

func is_facing_target_goal() -> bool:
	var direction_to_target = position.direction_to(target_goal.position)
	return heading.dot(direction_to_target) > 0
