extends Camera2D
@export var tile_map: TileMapLayer
@export var tile_map_boss_arena: TileMapLayer

var OFFSET: int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_rect = tile_map.get_used_rect()
	var quadrant_size = tile_map.rendering_quadrant_size
	var world_size = map_rect.size * quadrant_size
	print(map_rect.position.x,"\n Map rect size: ", map_rect.size,"\n Quadrant size: ", quadrant_size, "\n World size: ", world_size )
	self.limit_right = world_size.x + (map_rect.position.x - OFFSET) * quadrant_size
	self.limit_bottom = world_size.y + (map_rect.position.y - OFFSET) * quadrant_size
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = Player.position

func change_camera_to_boss_room():
	var position_in_world = tile_map_boss_arena.get_parent().position
	var map_rect_boss = tile_map_boss_arena.get_used_rect()
	var quadrant_size_boss = tile_map_boss_arena.rendering_quadrant_size
	var world_size_boss = map_rect_boss.size * quadrant_size_boss
	print(map_rect_boss,"\n Map rect size: ", map_rect_boss.size,"\n Quadrant size: ", quadrant_size_boss, "\n World size: ", world_size_boss )
	self.limit_left = position_in_world.x - abs(map_rect_boss.position.x * quadrant_size_boss)
	self.limit_top =  position_in_world.y - abs(map_rect_boss.position.y * quadrant_size_boss)
	self.limit_right = position_in_world.x - abs(map_rect_boss.position.x * quadrant_size_boss) + map_rect_boss.size.x * quadrant_size_boss
	self.limit_bottom = position_in_world.y - abs(map_rect_boss.position.y * quadrant_size_boss) + map_rect_boss.size.y * quadrant_size_boss
