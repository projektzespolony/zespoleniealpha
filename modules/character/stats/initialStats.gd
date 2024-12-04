extends Resource

class_name initialStats

#Default values
@export var max_health : int = 10
@export var speed : float = 500

@export var melee_attack_damage : float = 5
@export var melee_attack_speed : float = 2 #attacks per second
@export var ranged_attack_damage: float = 3
@export var ranged_attack_speed : float = 2 #attacks per second

#Modifiers
@export var  melee_attack_damage_modifier : float = 1
@export var  melee_attack_speed_modifier : float = 1
@export var  ranged_attack_damage_modifier : float = 1
@export var  ranged_attack_speed_modifier : float = 1
@export var speed_modifier : float = 1
@export var damage_reduction_modifier : float = 1
