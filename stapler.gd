extends Sprite2D
@export var Staple : PackedScene 

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func shoot():
	var b = Staple.instantiate()
	owner.get_parent().add_child(b)
	b.transform = $Muzzle.global_transform
