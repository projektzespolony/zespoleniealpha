class_name IsPlayerToClose extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	var distance_from_player: float = actor.get_distance_from_player()
	var enemy_too_close_range: int = actor.get_too_close_range()

	if distance_from_player <= enemy_too_close_range:
		return SUCCESS
	return FAILURE
