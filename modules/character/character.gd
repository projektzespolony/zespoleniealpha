extends CharacterBody2D

class_name Character

@export var base_stats: initialStats
@onready var stats = $Stats


func _ready() -> void:
	print("Stats:", stats)
	print("BaseStats: ", base_stats)
	stats.initialize(base_stats)


func take_damage(damage: int) -> void:
	if stats.health - damage <= 0:
		stats.health = 0
	else:
		stats.health -= damage
	print(stats.health, "took damage")
	if !is_alive():
		queue_free()


func is_alive() -> bool:
	return stats.health > 0


func get_movement_speed_modifier():
	return ((stats.speed) / 1000 + 0.5) * stats.speed_modifier
