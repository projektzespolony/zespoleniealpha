class_name KeepDistance extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !actor.check_navigation_status():
		return SUCCESS
	actor.keep_distance()
	return FAILURE
