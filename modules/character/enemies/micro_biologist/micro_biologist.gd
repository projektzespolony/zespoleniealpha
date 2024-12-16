class_name MicroBiologist extends Character

const TARGET_OFFSET: float = 200
const ATTACK_RANGE: float = 250

@export var charge_time: float = 2

var is_charged: bool = false
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var weapon_anchor: Area2D = $WeaponAnchor
@onready var weapon_hitbox: CollisionShape2D = $"WeaponAnchor/WeaponHitbox"


func get_distance_from_player() -> float:
	return self.global_position.distance_to(Player.global_position)


func get_attack_range() -> float:
	return ATTACK_RANGE


func get_too_close_range() -> float:
	return ATTACK_RANGE


func _physics_process(delta: float) -> void:
	weapon_anchor.look_at(Player.global_position)
	if navigation_agent_2d.is_navigation_finished():
		return
	var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	print(direction)
	self.velocity = (
		direction * get_movement_speed_modifier() * WorldContants.MOVEMENT_SPEED_MULTIPLIER * delta
	)
	move_and_slide()


func move() -> void:
	var direction_to_player: Vector2 = Player.global_position - global_position
	var target_offset: Vector2 = direction_to_player.normalized() * (ATTACK_RANGE - TARGET_OFFSET)
	navigation_agent_2d.target_position = Player.global_position - target_offset


func keep_distance() -> void:
	var direction_to_player: Vector2 = Player.global_position - global_position
	var move_direction: Vector2 = direction_to_player.normalized() * TARGET_OFFSET
	var target_position: Vector2 = Player.global_position - move_direction
	navigation_agent_2d.target_position = target_position


func check_navigation_status() -> bool:
	if navigation_agent_2d.get_navigation_map() == RID():
		return false
	return navigation_agent_2d.is_navigation_finished()


func is_attack_charged() -> bool:
	return is_charged


func prepare_charge_attack() -> void:
	await get_tree().create_timer(charge_time).timeout
	is_charged = true


func charged_attack() -> void:
	weapon_hitbox.disabled = false
	is_charged = false
	await get_tree().create_timer(charge_time).timeout
	weapon_hitbox.disabled = true


func _on_weapon_anchor_body_entered(body: Node2D) -> void:
	if !body.has_method("take_damage"):
		return
	var damage_to_deal: float = stats.melee_attack_damage * stats.melee_attack_damage_modifier
	body.take_damage(damage_to_deal)
