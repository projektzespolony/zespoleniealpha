extends Character

var player_input: PlayerInput


func _init() -> void:
	player_input = PlayerInput.new(self)
	add_child(player_input)


func take_damage(damage: int) -> void:
	stats.health -= damage / stats.damage_reduction
	print("PLAYER: ", self, "Current health: ", stats.health, " took ", damage)
	if !is_alive():
		game_over()


func game_over() -> void:
	#wlaczyc menusy
	print("GG LMAO")
