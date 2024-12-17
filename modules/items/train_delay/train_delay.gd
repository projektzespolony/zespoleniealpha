class_name TrainDelay extends BaseItem


func _on_interact() -> void:
	change_player_damage_reduction(item_stat_transformations.damage_reduction)
	change_player_melee_attack_speed(item_stat_transformations.melee_attack_speed)
	change_player_melee_attack_damage(item_stat_transformations.melee_attack_damage)
	queue_free()
