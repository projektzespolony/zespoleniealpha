class_name SigmaStorageExceeded extends BaseItem


func _on_interact() -> void:
	change_player_ranged_attack_damage(item_stat_transformations.ranged_attack_damage)
	change_player_melee_attack_damage(item_stat_transformations.melee_attack_damage)
	queue_free()
