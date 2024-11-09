extends Sprite2D
@export var Staple : PackedScene 

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("melee_attack"):
		melee()
		
func shoot():
	var b = Staple.instantiate()
	get_tree().get_root().add_child(b)
	b.transform = $Muzzle.global_transform

func melee():
	$MeleeArea.get_child(0).set_disabled(false) #CollisionShape2D 
	await get_tree().create_timer(0.2).timeout
	$MeleeArea.get_child(0).set_disabled(true)


func _on_melee_area_area_entered(area: Area2D) -> void:
	area.queue_free()
