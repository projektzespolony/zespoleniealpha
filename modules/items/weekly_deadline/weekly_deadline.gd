class_name WeeklyDeadline extends BaseItem


func _on_interact() -> void:
	change_player_max_health(item_stat_transformations.max_health)
	change_player_ranged_attack_speed(item_stat_transformations.ranged_attack_speed)
	change_player_ranged_attack_damage(item_stat_transformations.ranged_attack_damage)
	queue_free()
