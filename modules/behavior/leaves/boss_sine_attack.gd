class_name BossSineAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.boss_sine_attack()
	return SUCCESS
