class_name AIBehaviorFactory

var roles : Dictionary

func _init() -> void:
	roles = {
		Player.Role.GOALTE: AiBehaviorGolie,
		Player.Role.DEFENSE: AIBehaviorFeild,
		Player.Role.OFFENSE: AIBehaviorFeild,
		Player.Role.MIDFIELD: AIBehaviorFeild,
	}
func get_ai_behavior(role : Player.Role) -> AIbehavior:
	assert(roles.has(role), "role dosnt exist")
	return roles.get(role).new()
