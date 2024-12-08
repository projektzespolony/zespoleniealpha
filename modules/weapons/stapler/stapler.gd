extends Sprite2D

@export var staple: PackedScene

var melee_cooldown = false
var shoot_cooldown = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and not shoot_cooldown:
		shoot()

	if Input.is_action_just_pressed("melee_attack") and not melee_cooldown:
		melee()


func shoot() -> void:
	var shoot_speed = Player.stats.ranged_attack_damage * Player.stats.ranged_attack_speed_modifier
	shoot_cooldown = true
	var staple_instance = staple.instantiate()
	staple_instance.transform = $Muzzle.global_transform
	staple_instance.damage = (
		Player.stats.ranged_attack_damage * Player.stats.ranged_attack_damage_modifier
	)
	get_tree().get_root().add_child(staple_instance)
	await get_tree().create_timer(1.0 / shoot_speed).timeout
	shoot_cooldown = false


func melee() -> void:
	var attack_speed = Player.stats.melee_attack_speed * Player.stats.melee_attack_speed_modifier
	melee_cooldown = true
	$MeleeArea.get_child(0).set_disabled(false)  # CollisionShape2D
	await get_tree().create_timer(0.2).timeout
	$MeleeArea.get_child(0).set_disabled(true)
	await get_tree().create_timer(1.0 / attack_speed).timeout
	melee_cooldown = false


func _on_melee_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		var damage_to_deal = (
			Player.stats.melee_attack_damage * Player.stats.melee_attack_damage_modifier
		)
		body.take_damage(damage_to_deal)
