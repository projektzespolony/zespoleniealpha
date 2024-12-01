extends Area2D

@export var damage = 0;
var speed = 2000
var decayFactor = 0.95 #zanik predkosci

func _physics_process(delta):
	position += transform.x * speed * delta 
	speed *= decayFactor
	if speed <= 50: # dodanie zasięgu 
		queue_free()

func _on_area_entered(area: Area2D) -> void:	
	print("BULLET: Hit ",area, "dealing ", damage ," damage")
	#TODO: change to dealDmg() - requires enemy implementation
	area.queue_free()
	#remove staple when it hits
	queue_free()
