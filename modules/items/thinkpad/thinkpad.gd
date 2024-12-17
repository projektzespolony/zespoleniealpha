class_name Thinkpad extends BaseItem


func _on_interact() -> void:
	change_player_melee_attack_damage(item_stat_transformations.melee_attack_damage)
	queue_free()
