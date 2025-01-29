class_name DeleteRack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.delete_rack()
	return SUCCESS
