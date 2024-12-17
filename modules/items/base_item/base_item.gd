class_name BaseItem extends Node2D

@export var base_stats: initialStats
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var stats: Node = $Stats


func _ready() -> void:
	stats.initialize(base_stats)
	interaction_area.interact = Callable(self, "_on_interact")
	# new function for interaction
	# parameters: who has the function, 99% self, function name


func _on_interact() -> void:
	print("ITEM: Picked Up")


func change_player_health(value: int) -> void:
	var new_health_value : int = Player.stats.health + value
	Player.stats.set_health(new_health_value)


func change_player_max_health(value: int) -> void:
	var new_max_health_value : int = Player.stats.max_health + value
	Player.stats.set_max_health(new_max_health_value)


func change_player_melee_attack_damage(value: float) -> void:
	var new_melee_attack_damage : float = Player.stats.melee_attack_damage + value
	Player.stats.set_melee_attack_damage(new_melee_attack_damage)


func change_player_melee_attack_speed(value: float) -> void:
	var new_melee_attack_speed : float = Player.stats.melee_attack_speed + value
	Player.stats.set_melee_attack_speed(new_melee_attack_speed)


func change_player_ranged_attack_damage(value: float) -> void:
	var new_ranged_attack_damage : float = Player.stats.ranged_attack_damage + value
	Player.stats.set_ranged_attack_damage(new_ranged_attack_damage)


func change_player_ranged_attack_speed(value: float) -> void:
	var new_ranged_attack_speed : float = Player.stats.ranged_attack_speed + value
	Player.stats.set_ranged_attack_speed(new_ranged_attack_speed)


func change_player_speed(value: float) -> void:
	var new_speed : float = Player.stats.speed + value
	Player.stats.set_speed(new_speed)


func change_player_damage_reduction(value: float) -> void:
	var new_damage_reduction : float = Player.stats.damage_reduction + value
	Player.stats.set_damage_reduction(new_damage_reduction)


func change_player_melee_attack_damage_modifier(value: float) -> void:
	var new_melee_attack_damage_modifier : float = Player.stats.melee_attack_damage_modifier * value
	Player.stats.set_melee_attack_damage_modifier(new_melee_attack_damage_modifier)


func change_player_melee_attack_speed_modifier(value: float) -> void:
	var new_melee_attack_speed_modifier : float = Player.stats.melee_attack_speed_modifier * value
	Player.stats.set_melee_attack_speed_modifier(new_melee_attack_speed_modifier)


func change_player_ranged_attack_damage_modifier(value: float) -> void:
	var new_ranged_attack_damage_modifier : float = Player.stats.ranged_attack_damage_modifier * value
	Player.stats.set_ranged_attack_damage_modifier(new_ranged_attack_damage_modifier)


func change_player_ranged_attack_speed_modifier(value: float) -> void:
	var new_ranged_attack_speed_modifier : float = Player.stats.ranged_attack_speed_modifier * value
	Player.stats.set_ranged_attack_speed_modifier(new_ranged_attack_speed_modifier)


func change_player_speed_modifier(value: float) -> void:
	var new_speed_modifier : float = Player.stats.speed_modifier * value
	Player.stats.set_speed_modifier(new_speed_modifier)
