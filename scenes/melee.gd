extends Sprite2D

func _process(_delta: float) -> void:
	if Input.is_action_pressed("melee_attack"):
		if $Hitbox.is_colliding():
			print("whatever")
