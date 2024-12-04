extends Sprite2D

@export var Staple: PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("melee_attack"):
		melee()

func shoot() -> void:
	var staple_instance = Staple.instantiate()
	staple_instance.position = $Muzzle.global_position
	staple_instance.rotation = $Muzzle.global_rotation
	get_tree().get_root().add_child(staple_instance)

func melee() -> void:
	$MeleeArea.get_child(0).set_disabled(false)  # CollisionShape2D
	await get_tree().create_timer(0.2).timeout
	$MeleeArea.get_child(0).set_disabled(true)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(10)
