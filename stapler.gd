extends Sprite2D
@export var Staple : PackedScene 

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func shoot():
	var b = Staple.instantiate()
	get_tree().get_root().add_child(b)
	b.transform = $Muzzle.global_transform
