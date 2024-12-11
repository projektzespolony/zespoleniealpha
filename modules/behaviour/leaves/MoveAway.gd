class_name MoveAway extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.move_away()
	return SUCCESS
