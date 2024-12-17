class_name Eduroam extends BaseItem


func _on_interact() -> void:
	change_player_damage_reduction(item_stat_transformations.damage_reduction)
	change_player_speed(item_stat_transformations.speed)
	queue_free()
