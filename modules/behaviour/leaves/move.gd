class_name Move extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !actor.check_navigation_status():
		return SUCCESS
	actor.move()
	return FAILURE
