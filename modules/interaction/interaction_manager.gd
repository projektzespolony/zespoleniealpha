extends Node2D

const BASE_TEXT: String = "[E] to "

var active_areas = []
var can_interact = true

@onready var label = $Label


func register_area(area: InteractionArea):
	print("INTERACTION_MANAGER: Registered new area")
	active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	print("INTERACTION_MANAGER: Unregistered an area")
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)

		# positioning the label
		label.text = BASE_TEXT + active_areas[0].interaction_name
		label.global_position = active_areas[0].global_position  # show above active area
		label.global_position.y -= 50  # y offset
		label.global_position.x -= label.size.x / 2  # center the text

		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = Player.global_position.distance_to(area1.global_position)
	var area2_to_player = Player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()

			await active_areas[0].interact.call()  # activate the callable function

			can_interact = true
