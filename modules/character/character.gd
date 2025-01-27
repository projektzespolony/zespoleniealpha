class_name Character
extends CharacterBody2D

@export var base_stats: initialStats
@onready var stats: Stats = $Stats


func _ready() -> void:
	print("Stats:", stats)
	print("BaseStats: ", base_stats)
	stats.initialize(base_stats)


func take_damage(damage: int) -> void:
	stats.health -= int(damage / stats.damage_reduction)
	print("CHARACTER: ", self, "Current health: ", stats.health, " took ", damage)
	if !is_alive():
		queue_free()


func is_alive() -> bool:
	return stats.health > 0


func get_movement_speed_modifier() -> float:
	return ((stats.speed) / 1000 + 0.5) * stats.speed_modifier
