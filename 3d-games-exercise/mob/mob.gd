extends RigidBody3D

const MOBSPEED = 6.5
const PLAYER_DAMAGE=1

var health = 5

@onready var bat_model: Node3D = %Bat_model
@onready var player = $/root/GAME/Player
@onready var timer: Timer = %Timer

func take_damage():
	if(health==0):
		return
	
	bat_model.hurt()
	health-=PLAYER_DAMAGE
	if health==0:
		set_physics_process(false)
		gravity_scale=1.0
		var direction2 = -global_position.direction_to(player.global_position)
		var up_repulsive_force =  Vector3.UP * randf_range(0.5,1)
		apply_central_impulse(up_repulsive_force+direction2*15)
		timer.start()
		lock_rotation = false
	
	


func _physics_process(_delta: float) -> void:
	
	var direction = global_position.direction_to(player.global_position)
	direction.y+=0.5
	
	linear_velocity=direction*MOBSPEED
	bat_model.rotation.y=Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)+PI
	
	
	#print(bat_model.rotation.x, bat_model.rotation.z)
	
	


func _on_timer_timeout() -> void:
	queue_free()
