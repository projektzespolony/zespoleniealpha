extends Area2D

var speed = 2000
var decayFactor = 0.95 #zanik predkosci

func _physics_process(delta):
	position += transform.x * speed * delta 
	speed *= decayFactor
	if speed <= 50: # dodanie zasięgu 
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()
