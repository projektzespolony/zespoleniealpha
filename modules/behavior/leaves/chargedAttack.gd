class_name chargedAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.charged_attack()
	return SUCCESS
