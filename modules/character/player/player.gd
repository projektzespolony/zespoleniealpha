extends Character

@export var death_level: PackedScene = preload("res://modules/world/death_scene/death_scene.tscn")
var player_input: PlayerInput


func _init() -> void:
	player_input = PlayerInput.new(self)
	add_child(player_input)


func take_damage(damage: int) -> void:
	stats.health -= int(damage / stats.damage_reduction)
	print("PLAYER: ", self, "Current health: ", stats.health, " took ", damage)
	if !is_alive():
		game_over()


func game_over() -> void:
	#wlaczyc menusy
	print("GG LMAO")
	get_tree().change_scene_to_packed(death_level)
