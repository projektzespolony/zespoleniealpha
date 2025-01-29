class_name UseFirewall extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_firewall_running():
		return RUNNING
	actor.use_firewall()
	return SUCCESS
