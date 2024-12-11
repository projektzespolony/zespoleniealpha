class_name Explode extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.explode()
	return SUCCESS
