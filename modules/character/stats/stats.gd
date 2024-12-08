extends Node

var health: int
var max_health: int
var melee_attack_damage: float
var melee_attack_speed: float
var ranged_attack_damage: float
var ranged_attack_speed: float
var speed: float
var damage_reduction: float

# Modifiers
var melee_attack_damage_modifier: float
var melee_attack_speed_modifier: float
var ranged_attack_damage_modifier: float
var ranged_attack_speed_modifier: float
var speed_modifier: float


func initialize(stats: initialStats):
	# Health
	max_health = stats.max_health
	health = max_health

	# Speed
	speed = stats.speed
	speed_modifier = stats.speed_modifier

	# Damage reduction
	damage_reduction = stats.damage_reduction_modifier

	# Melee
	melee_attack_damage = stats.melee_attack_damage
	melee_attack_speed = stats.melee_attack_speed

	# Melee modifier
	melee_attack_damage_modifier = stats.melee_attack_damage_modifier
	melee_attack_speed_modifier = stats.melee_attack_speed_modifier

	# Ranged
	ranged_attack_damage = stats.ranged_attack_damage
	ranged_attack_speed = stats.ranged_attack_speed

	# Ranged modifier
	ranged_attack_damage_modifier = stats.melee_attack_damage_modifier
	ranged_attack_speed_modifier = stats.ranged_attack_speed_modifier


func take_dmg(amount: int):
	health -= int(amount / damage_reduction)


#
# Setters
#


func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)


func set_max_health(value: int) -> void:
	max_health = max(value, 1)


func set_melee_attack_damage(value: float) -> void:
	melee_attack_damage = max(value, 0.1)


func set_melee_attack_speed(value: float) -> void:
	melee_attack_speed = max(value, 0.1)


func set_ranged_attack_damage(value: float) -> void:
	ranged_attack_damage = max(value, 0.1)


func set_ranged_attack_speed(value: float) -> void:
	ranged_attack_speed = max(value, 0.1)


func set_speed(value: float) -> void:
	speed = max(value, 0.1)


func set_damage_reduction(value: float) -> void:
	damage_reduction = max(value, 1.0)  # Avoid division by zero


#
# Modifiers setters
#


func set_melee_attack_damage_modifier(value: float) -> void:
	melee_attack_damage_modifier = value


func set_melee_attack_speed_modifier(value: float) -> void:
	melee_attack_speed_modifier = value


func set_ranged_attack_damage_modifier(value: float) -> void:
	ranged_attack_damage_modifier = value


func set_ranged_attack_speed_modifier(value: float) -> void:
	ranged_attack_speed_modifier = value


func set_speed_modifier(value: float) -> void:
	speed_modifier = value
