class_name ChargeAtPlayer extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.charge()
	return SUCCESS
