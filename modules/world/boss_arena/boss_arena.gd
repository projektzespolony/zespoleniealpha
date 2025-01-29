class_name BossArena extends Node2D

@export var boss: PackedScene
@onready var announcement_block: Control = $Announcement
@onready var text_blocks: Control = $Announcement/Components/Text
@onready var spawn_point: Node2D = $SpawnPoint
@onready var player_spawn_point: Node2D = $PlayerSpawnPoint


func start_boss_fight() -> void:
	get_tree().call_group("Camera", "change_camera_to_boss_room")
	await boss_intro()
	var entity: Node = boss.instantiate()
	entity.position = spawn_point.global_position
	Player.position = player_spawn_point.global_position
	get_tree().current_scene.call_deferred("add_child", entity)


func boss_intro() -> void:
	Player.visible = false
	announcement_block.visible = true
	for text in text_blocks.get_children():
		text.visible = true
		await get_tree().create_timer(0.8).timeout
	announcement_block.visible = false
	Player.visible = true
