class_name PrepareChargedAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.prepare_charge_attack()
	return SUCCESS
