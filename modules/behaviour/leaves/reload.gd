class_name Reload extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.reload()
	return SUCCESS
