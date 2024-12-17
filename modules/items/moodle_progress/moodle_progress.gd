class_name MoodleProgress extends BaseItem


func _on_interact() -> void:
	change_player_damage_reduction(item_stat_transformations.damage_reduction)
	change_player_melee_attack_speed(item_stat_transformations.melee_attack_speed)
	queue_free()
