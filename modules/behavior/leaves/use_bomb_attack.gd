class_name UseBombAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.use_bomb_attack()
	return SUCCESS
