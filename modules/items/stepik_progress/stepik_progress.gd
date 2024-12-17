class_name StepikProgress extends BaseItem


func _on_interact() -> void:
	change_player_speed(item_stat_transformations.speed)
	change_player_melee_attack_speed(item_stat_transformations.melee_attack_speed)
	queue_free()
