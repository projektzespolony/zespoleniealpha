class_name IsCharged extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_attack_charged():
		return SUCCESS
	return FAILURE
