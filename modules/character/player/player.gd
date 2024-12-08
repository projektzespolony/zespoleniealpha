extends Character

var player_input: PlayerInput


func _init():
	player_input = PlayerInput.new(self)
	add_child(player_input)
