extends Node2D

const BASE_TEXT: String = "[E] to "
const SHOW_DETAILS_TEXT: String = "[Q] to show/hide details"

var active_areas: Array = []
var can_interact: bool = true

@onready var label: Label = $Label


func register_area(area: InteractionArea) -> void:
	print("INTERACTION_MANAGER: Registered new area")
	active_areas.push_back(area)


func unregister_area(area: InteractionArea) -> void:
	print("INTERACTION_MANAGER: Unregistered an area")
	var index: int = active_areas.find(area)
	if index == -1:
		return
	active_areas.remove_at(index)


func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)

		# positioning the label
		label.text = BASE_TEXT + active_areas[0].interaction_name + "\n" + SHOW_DETAILS_TEXT
		label.global_position = active_areas[0].global_position  # show above active area
		label.global_position.y -= 50  # y offset
		label.global_position.x -= label.size.x / 2  # center the text

		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1: Area2D, area2: Area2D) -> bool:
	var area1_to_player: float = Player.global_position.distance_to(area1.global_position)
	var area2_to_player: float = Player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if !active_areas.size() > 0:
			return
		can_interact = false
		label.hide()
		await active_areas[0].interact.call()  # activate the callable function
		can_interact = true
	if event.is_action_pressed("show_details") and can_interact:
		if !active_areas.size() > 0:
			return
		can_interact = false
		label.hide()
		await active_areas[0].show_details.call()  # activate the callable function
		can_interact = true
