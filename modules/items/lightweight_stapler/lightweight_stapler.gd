class_name LightweightStapler extends BaseItem


func _on_interact() -> void:
	change_player_ranged_attack_speed(item_stat_transformations.ranged_attack_speed)
	queue_free()
