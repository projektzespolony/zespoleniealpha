class_name IsPlayerWithinAttackRange extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	var distance_from_player: float = actor.get_distance_from_player()
	print(distance_from_player)
	var enemy_attack_range: int = actor.get_attack_range()

	if distance_from_player <= enemy_attack_range:
		return SUCCESS
	return FAILURE
