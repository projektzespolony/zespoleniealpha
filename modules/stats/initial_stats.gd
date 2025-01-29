# gdlint:ignore=class-name
class_name initialStats
extends Resource

# Default values
@export var max_health: int = 0
@export var speed: float = 0
@export var melee_attack_damage: float = 0
@export var melee_attack_speed: float = 0  # attacks per second
@export var ranged_attack_damage: float = 0
@export var ranged_attack_speed: float = 0  # attacks per second

# Modifiers
@export var melee_attack_damage_modifier: float = 1
@export var melee_attack_speed_modifier: float = 1
@export var ranged_attack_damage_modifier: float = 1
@export var ranged_attack_speed_modifier: float = 1
@export var speed_modifier: float = 1
@export var damage_reduction_modifier: float = 1
