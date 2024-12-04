extends CharacterBody2D

class_name Character

@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 10
@export var strength: int = 10

func _init(_health: int, _max_health: int, _speed: float, _strength: int) -> void:
	health = _health
	max_health = _max_health
	speed = _speed
	strength = _strength

func take_damage(damage: int) -> void:
	if health - damage <= 0:
		health = 0
		return

	health -= damage

	if !is_alive():
		queue_free()



func is_alive() -> bool:
	return health > 0

func get_movement_speed_modifier() -> float:
	if speed <= 0:
		return 0

	return 1.0 + (speed / 400.0)
