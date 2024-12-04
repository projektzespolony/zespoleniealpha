extends Sprite2D

@export var Staple: PackedScene
@export var player : CharacterBody2D

var melee_cooldown = false
var shoot_cooldown = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("melee_attack"):
		melee()

func shoot() -> void:
	var shoot_speed = player.stats.ranged_attack_speed if player else 1.0
	shoot_cooldown = true
	var staple_instance = Staple.instantiate()
	staple_instance.position = $Muzzle.global_position
	staple_instance.rotation = $Muzzle.global_rotation
	get_tree().get_root().add_child(staple_instance)
	await get_tree().create_timer(1.0 / shoot_speed).timeout
	shoot_cooldown = false

func melee() -> void:
	var attack_speed = player.stats.melee_attack_speed if player else 1.0
	melee_cooldown = true
	$MeleeArea.get_child(0).set_disabled(false)  # CollisionShape2D
	await get_tree().create_timer(0.2).timeout
	$MeleeArea.get_child(0).set_disabled(true)
	await get_tree().create_timer(1.0 / attack_speed).timeout
	melee_cooldown = false

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(10)
