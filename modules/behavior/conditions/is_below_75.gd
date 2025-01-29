class_name IsBelow75 extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_below_75():
		return SUCCESS
	return FAILURE
