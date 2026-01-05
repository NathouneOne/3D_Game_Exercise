extends RigidBody3D

signal mob_died

const PLAYER_DAMAGE=1

var mob_speed = randf_range(4.0,6.5)
var health = 5

@onready var bat_model: Node3D = %Bat_model
@onready var player = $/root/GAME/Player
@onready var timer: Timer = %Timer
@onready var take_damage_audio: AudioStreamPlayer3D = %Take_Damage_audio
@onready var ko_audio: AudioStreamPlayer3D = %Ko_audio

func take_damage():
	if(health==0):
		return
	
	take_damage_audio.play()
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
		ko_audio.play()
	
	


func _physics_process(_delta: float) -> void:
	
	var direction = global_position.direction_to(player.global_position)
	direction.y+=0.2
	
	linear_velocity=direction*mob_speed
	bat_model.rotation.y=Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)+PI
	
	
	#print(bat_model.rotation.x, bat_model.rotation.z)
	


func _on_timer_timeout() -> void:
	queue_free()
	mob_died.emit()
