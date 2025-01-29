class_name IsBelow50 extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_below_50():
		return SUCCESS
	return FAILURE
