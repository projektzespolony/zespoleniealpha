class_name TakeoutDinner extends BaseItem


func _on_interact() -> void:
	change_player_max_health(item_stat_transformations.max_health)
	queue_free()
