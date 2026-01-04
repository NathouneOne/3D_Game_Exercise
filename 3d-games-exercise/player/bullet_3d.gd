extends Area3D

const SPEED = 40.0
const RANGE = 250

var traveled_distance=0.0


func _physics_process(delta: float) -> void:
	
	position += -transform.basis.z * SPEED * delta
	traveled_distance += SPEED * delta
	
	if traveled_distance > RANGE:
		queue_free() 


func _on_body_entered(body: Node3D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
	
