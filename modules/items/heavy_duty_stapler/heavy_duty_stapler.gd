class_name HeavyDutyStapler extends BaseItem


func _on_interact() -> void:
	change_player_ranged_attack_damage(item_stat_transformations.ranged_attack_damage)
	queue_free()
