extends Sprite2D
@export var Staple : PackedScene
@export var player : CharacterBody2D

var melee_cooldown = false
var shoot_cooldown = false

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot") and not shoot_cooldown:
		shoot()
		
	if Input.is_action_just_pressed("melee_attack") and not melee_cooldown:
		melee()
		
func shoot():
	var shoot_speed = player.stats.ranged_attack_speed if player else 1.0
	shoot_cooldown = true
	var bullet = Staple.instantiate()
	bullet.damage = player.stats.ranged_attack_damage
	get_tree().get_root().add_child(bullet)
	bullet.transform = $Muzzle.global_transform
	await get_tree().create_timer(1.0 / shoot_speed).timeout
	shoot_cooldown = false

func melee():
	var attack_speed = player.stats.melee_attack_speed if player else 1.0
	melee_cooldown = true
	$MeleeArea.get_child(0).set_disabled(false)
	await get_tree().create_timer(0.2).timeout
	$MeleeArea.get_child(0).set_disabled(true)
	await get_tree().create_timer(1.0 / attack_speed).timeout
	melee_cooldown = false


func _on_melee_area_area_entered(area: Area2D) -> void:
	print("MELEE: Hit ", area, "for ", player.stats.melee_attack_damage)
	#TODO: change to dealDmg() - requires enemy implementation
	area.queue_free()
