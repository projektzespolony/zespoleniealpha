extends Node

var health : int
var max_health : int
var melee_attack_damage : float
var melee_attack_speed : float
var ranged_attack_damage : float
var ranged_attack_speed : float
var speed : float
var damage_reduction : float 

func initialize(stats : initialStats):
	max_health = stats.max_health
	health = max_health
	speed = stats.speed * stats.speed_modifier
	damage_reduction = stats.damage_reduction_modifier
	#set weapons dmg
	melee_attack_damage = stats.melee_attack_damage * stats.melee_attack_damage_modifier
	melee_attack_speed = stats.melee_attack_speed * stats.melee_attack_speed_modifier
	ranged_attack_damage = stats.ranged_attack_damage * stats.ranged_attack_damage_modifier
	ranged_attack_speed = stats.ranged_attack_speed * stats.ranged_attack_speed_modifier

func take_dmg(amount: int):
	health -= int(amount / damage_reduction)
	
