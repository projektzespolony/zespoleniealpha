extends Node

class_name Character

var health: int
var max_health: int
var speed: float
var strength: int

func _init(_health: int, _max_health: int, _speed: float, _strength: int):
    health = _health
    max_health = _max_health
    speed = _speed
    strength = _strength

func take_damage(damage: int):
    health -= damage
    if health < 0:
        health = 0

func is_alive() -> bool:
    return health > 0
