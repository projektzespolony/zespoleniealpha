class_name GymMembership extends BaseItem


func _on_interact() -> void:
	change_player_melee_attack_damage(item_stat_transformations.melee_attack_damage)
	change_player_damage_reduction(item_stat_transformations.damage_reduction)
	queue_free()
