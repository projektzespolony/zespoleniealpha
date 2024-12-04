extends CharacterBody2D

class_name Character

@export var baseStats: initialStats
@onready var stats = $Stats

func _ready() -> void:
	print("Stats:", stats )
	print("BaseStats: ", baseStats)
	stats.initialize(baseStats)
	
func take_damage(damage: int) -> void:
	if stats.health - damage <= 0:
		stats.health = 0
		return
	
	stats.health -= damage
	print( stats.health, "took damage")
	if !is_alive():
		queue_free()

func is_alive() -> bool:
	return stats.health > 0

func get_movement_speed_modifier():
	return stats.speed/400 + 1
