extends Resource

class_name startingStats

@export var entity_name : String = "base_entity"

#Default values
@export var max_health : int = 10
@export var attack_damage : float = 5
@export var attack_speed : float = 0.5
@export var speed : float = 500

#Modifiers
@export var attack_damage_modifier : float = 1
@export var attack_speed_modifier : float = 1
@export var speed_modifier : float = 1
@export var damage_reduction_modifier : float = 1
