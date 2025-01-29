class_name UseSineAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.use_sine_attack()
	return SUCCESS
