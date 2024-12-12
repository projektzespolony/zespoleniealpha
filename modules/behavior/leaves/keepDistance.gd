class_name KeepDistance extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.keep_distance()
	return SUCCESS
	
