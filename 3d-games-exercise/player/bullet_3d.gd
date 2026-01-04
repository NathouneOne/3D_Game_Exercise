extends Area3D

const SPEED = 40.0
const RANGE = 250
const COMPENSATION_X = 0.5
const COMPENSATION_Y = 0.3

var traveled_distance=0.0

#########################################################
## DOESNT SHOOT WHILE MOVING BACKWARD WTFFFFF##

func _physics_process(delta: float) -> void:
	
	position += -transform.basis.z * SPEED * delta
	##trajectory angle compensation
	#position += -transform.basis.x * COMPENSATION_X * delta
	position += transform.basis.y * COMPENSATION_Y * delta
	traveled_distance += SPEED * delta
	
	if traveled_distance > RANGE:
		queue_free() 


func _on_body_entered(body: Node3D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
	
