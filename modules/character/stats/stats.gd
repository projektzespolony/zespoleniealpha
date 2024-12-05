extends Node

var health: int
var max_health: int
var melee_attack_damage: float
var melee_attack_speed: float
var ranged_attack_damage: float
var ranged_attack_speed: float
var speed: float
var damage_reduction: float
#modifiers
var melee_attack_damage_modifier: float
var melee_attack_speed_modifier: float
var ranged_attack_damage_modifier: float
var ranged_attack_speed_modifier: float
var speed_modifier: float


func initialize(stats: initialStats):
	#health
	max_health = stats.max_health
	health = max_health
	#speed
	speed = stats.speed
	speed_modifier = stats.speed_modifier
	#damage_reduction
	damage_reduction = stats.damage_reduction_modifier
	#melee
	melee_attack_damage = stats.melee_attack_damage
	melee_attack_speed = stats.melee_attack_speed
	#melee modifier
	melee_attack_damage_modifier = stats.melee_attack_damage_modifier
	melee_attack_speed_modifier = stats.melee_attack_speed_modifier
	#ranged
	ranged_attack_damage = stats.ranged_attack_damage
	ranged_attack_speed = stats.ranged_attack_speed
	#ranged_modifier
	ranged_attack_damage_modifier = stats.melee_attack_damage_modifier
	ranged_attack_speed_modifier = stats.ranged_attack_speed_modifier


func take_dmg(amount: int):
	health -= int(amount / damage_reduction)
