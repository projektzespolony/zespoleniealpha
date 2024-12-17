class_name EnergyDrink extends BaseItem


func _on_interact() -> void:
	change_player_speed(item_stat_transformations.speed)
	queue_free()
