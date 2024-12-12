class_name MicroBiologist extends Character

const TARGET_OFFSET: float = 200
const ATTACK_RANGE: float = 300

@export var charge_time: float = 2
var is_charged: bool = false
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func get_distance_from_player() -> float:
	return self.global_position.distance_to(Player.global_position)


func get_attack_range() -> float:
	return ATTACK_RANGE


func get_too_close_range() -> float:
	return ATTACK_RANGE


func _physics_process(delta: float) -> void:
	if !navigation_agent_2d.is_navigation_finished():
		var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		print(direction)
		self.velocity = (
			direction
			* get_movement_speed_modifier()
			* WorldContants.MOVEMENT_SPEED_MULTIPLIER
			* delta
		)
		move_and_slide()


func move() -> void:
	var direction_to_player: Vector2 = Player.global_position - global_position
	var target_offset: Vector2 = direction_to_player.normalized() * (ATTACK_RANGE - TARGET_OFFSET)
	navigation_agent_2d.target_position = Player.global_position - target_offset


func keep_distance() -> void:
	var direction_to_player: Vector2 = Player.global_position - global_position
	var move_direction: Vector2 = direction_to_player.normalized()
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
	#TODO: IMPLEMENT A WEAPON
	print("TODO: Implement Weapon Attack")
	is_charged = false
