class_name Franke extends Character

const ATTACK_RANGE: float = 500
const TOO_CLOSE_RANGE: float = 300

var shoot_cooldown: bool = false
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func get_distance_from_player() -> float:
	return self.global_position.distance_to(Player.global_position)


func get_attack_range() -> float:
	return ATTACK_RANGE


func get_too_close_range() -> float:
	return TOO_CLOSE_RANGE


func can_shoot() -> bool:
	return !shoot_cooldown


func shoot() -> void:
	var direction: Vector2 = (Player.global_position - self.global_position).normalized()
	var projectile: Node = (
		preload("res://modules/character/enemies/franke/projectile/enemy_staple.tscn").instantiate()
	)
	var angle_to_player: float = direction.angle()
	projectile.rotation = angle_to_player
	get_tree().get_root().add_child(projectile)
	projectile.global_position = global_position
	shoot_cooldown = true
	await (
		get_tree()
		. create_timer(1.0 / (stats.ranged_attack_speed * stats.ranged_attack_speed_modifier))
		. timeout
	)
	shoot_cooldown = false


func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	self.velocity = (
		direction * get_movement_speed_modifier() * WorldContants.MOVEMENT_SPEED_MULTIPLIER * delta
	)
	move_and_slide()


func find_farthest_point_from_player(
	player_position: Vector2, search_radius: float = 500, sample_points: int = 64
) -> Vector2:
	var best_position: Vector2 = global_position
	var max_distance: float = 0
	var nav_map_rid: RID = navigation_agent_2d.get_navigation_map()
	if nav_map_rid == RID():
		return best_position

	for i in range(sample_points):
		var angle: float = i * TAU / sample_points
		var offset: Vector2 = Vector2(cos(angle), sin(angle)) * search_radius
		var test_position: Vector2 = global_position + offset

		var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(
			nav_map_rid, test_position
		)
		if closest_point != Vector2():
			var distance_to_player: float = player_position.distance_to(closest_point)
			var center_distance: float = closest_point.distance_to(global_position)
			if distance_to_player > max_distance and center_distance < search_radius * 0.9:
				max_distance = distance_to_player
				best_position = closest_point

	return best_position


func move_away() -> void:
	var farthest_point: Vector2 = find_farthest_point_from_player(Player.global_position)
	navigation_agent_2d.target_position = farthest_point


func move() -> void:
	var direction_to_player: Vector2 = Player.global_position - global_position
	var target_offset: Vector2 = direction_to_player.normalized() * (ATTACK_RANGE - 100)
	navigation_agent_2d.target_position = Player.global_position - target_offset


func reload() -> void:
	print("Franke: RELOADING")  #granie animacji


func check_navigation_status() -> bool:
	if navigation_agent_2d.get_navigation_map() == RID():
		return false
	return navigation_agent_2d.is_navigation_finished()
