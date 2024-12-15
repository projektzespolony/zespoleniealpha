class_name CanShoot extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.can_shoot():
		return SUCCESS
	return FAILURE
