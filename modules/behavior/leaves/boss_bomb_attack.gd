class_name BossBombAttack extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.boss_bomb_attack()
	return SUCCESS
