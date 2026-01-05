extends RigidBody3D

const MOBSPEED = 6.5

@onready var bat_model: Node3D = %Bat_model
@onready var player = $/root/GAME/Player

func take_damage():
	bat_model.hurt()



func _physics_process(_delta: float) -> void:
	
	var direction = global_position.direction_to(player.global_position)
	direction.y+=0.5
	
	linear_velocity=direction*MOBSPEED
	bat_model.rotation.y=Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)+PI
	
	
	#print(bat_model.rotation.x, bat_model.rotation.z)
	
	
