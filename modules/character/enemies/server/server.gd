class_name Server extends Character

@export var firewall_projectile_scene: PackedScene
@export var cache_bomb_scene: PackedScene
@export var sine_wave_scene: PackedScene

var ordered_racks: Array[Node]
var first_rack_destroyed: bool = false
var second_rack_destroyed: bool = false
var firewall_running: bool = false

@onready var server_racks: Node2D = $ServerRacks


func _ready() -> void:
	stats.initialize(base_stats)
	ordered_racks = server_racks.get_children()
	ordered_racks.shuffle()


func firewall(target: Node2D) -> void:
	var firewall: Node = firewall_projectile_scene.instantiate()
	firewall.damage = stats.ranged_attack_damage * stats.ranged_attack_damage_modifier
	firewall.position = target.global_position
	get_tree().current_scene.call_deferred("add_child", firewall)


func bomb_attack(target: Node2D) -> void:
	var cache_bomb: Node = cache_bomb_scene.instantiate()
	var direction: Vector2 = (Player.global_position - target.global_position).normalized()
	var angle_to_player: float = direction.angle()
	cache_bomb.rotation = angle_to_player
	cache_bomb.position = target.global_position
	cache_bomb.damage = stats.ranged_attack_damage * stats.ranged_attack_damage_modifier * 2
	get_tree().current_scene.call_deferred("add_child", cache_bomb)


func sine_attack(target: Node2D) -> void:
	var sine_wave: Node = sine_wave_scene.instantiate()
	var direction: Vector2 = (Player.global_position - target.global_position).normalized()
	var angle_to_player: float = direction.angle()
	sine_wave.rotation = angle_to_player
	sine_wave.damage = stats.ranged_attack_damage * stats.ranged_attack_damage_modifier
	sine_wave.position = target.global_position
	get_tree().current_scene.call_deferred("add_child", sine_wave)


func use_sine_attack() -> void:
	if len(ordered_racks) <= 0:
		return
	sine_attack(ordered_racks[0])


func use_bomb_attack() -> void:
	if len(ordered_racks) <= 0:
		return
	bomb_attack(ordered_racks[1])


func use_firewall() -> void:
	firewall_running = true
	for i in range(5):
		await get_tree().create_timer(0.2).timeout
		firewall(self)
	firewall_running = false


func is_below_75() -> bool:
	return stats.health <= stats.max_health * 0.75


func is_below_50() -> bool:
	return stats.health <= stats.max_health * 0.5


func is_firewall_running() -> bool:
	return firewall_running


func boss_sine_attack():
	sine_attack(self)


func boss_bomb_attack():
	bomb_attack(self)


func delete_rack() -> void:
	if len(ordered_racks) <= 0:
		return
	if is_below_75() and !first_rack_destroyed:
		ordered_racks[-1].visible = false
		ordered_racks[-1].get_child(0).queue_free()
		ordered_racks.pop_at(-1)
		first_rack_destroyed = true
	if is_below_50() and !second_rack_destroyed:
		ordered_racks[-1].visible = false
		ordered_racks[-1].get_child(0).queue_free()
		ordered_racks.pop_at(-1)
		second_rack_destroyed = true


func take_damage(damage: int) -> void:
	stats.health -= int(damage / stats.damage_reduction)
	print("CHARACTER: ", self, "Current health: ", stats.health, " took ", damage)
	if !is_alive():
		print("DEATH: signaling observer")
		get_tree().call_group("Spawner", "check_end_of_stage_staus")
		#victory screen
		queue_free()
