class_name Franke extends Character
const ATTACK_RANGE: int = 500
var shoot_cooldown: bool = false


func get_distance_from_player() -> float:
	return self.global_position.distance_to(Player.global_position)


func get_attack_range() -> int:
	return ATTACK_RANGE


func can_shoot() -> bool:
	return !shoot_cooldown


func shoot() -> void:
	var direction: Vector2 = (Player.global_position - self.global_position).normalized()
	var projectile: Node = (
		preload("res://modules/character/enemies/franke/projectile/enemy_staple.tscn").instantiate()
	)
	var angle_to_player: float = direction.angle()
	projectile.rotation = angle_to_player
	add_child(projectile)
	projectile.global_position = global_position
	shoot_cooldown = true
	await get_tree().create_timer(1.0).timeout
	shoot_cooldown = false


func reload() -> void:
	print("Franke: RELOADING")  #granie animacji
