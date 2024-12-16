class_name IsAttackCharged extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_attack_charged():
		return SUCCESS
	return FAILURE
