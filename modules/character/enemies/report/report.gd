class_name Report extends Character

const ATTACK_RANGE: float = 350
const TOO_CLOSE_RANGE: float = 250

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var explosion_hitbox: Area2D = $ExplosionHitbox


func get_distance_from_player() -> float:
	return self.global_position.distance_to(Player.global_position)


func get_attack_range() -> float:
	return ATTACK_RANGE


func get_too_close_range() -> float:
	return TOO_CLOSE_RANGE


func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	print(direction)
	self.velocity = (
		direction * get_movement_speed_modifier() * WorldContants.MOVEMENT_SPEED_MULTIPLIER * delta
	)
	move_and_slide()


func charge_at_player() -> void:
	navigation_agent_2d.target_position = Player.global_position


func explode() -> void:
	await get_tree().create_timer(1.0).timeout
	explosion_hitbox.get_child(0).set_disabled(false)
	await get_tree().create_timer(1).timeout
	queue_free()


func _on_explosion_hitbox_body_entered(body: Node2D) -> void:
	if !body.has_method("take_damage"):
		return
	var damage_to_deal: float = stats.melee_attack_damage * stats.melee_attack_damage_modifier
	body.take_damage(damage_to_deal)
