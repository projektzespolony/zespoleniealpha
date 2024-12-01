extends Node

var health : int
var max_health : int
var attack_damage : float
var attack_speed : float
var speed : float
var damage_reduction : float 

func initialize(stats : startingStats):
	max_health = stats.max_health
	health = max_health
	attack_damage = stats.attack_damage * stats.attack_damage_modifier
	attack_speed = stats.attack_speed * stats.attack_speed_modifier
	speed = stats.speed * stats.attack_speed_modifier
	damage_reduction = stats.damage_reduction_modifier

func take_dmg(amount: int):
	health -= int(amount * damage_reduction)
	
