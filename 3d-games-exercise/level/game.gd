extends Node3D

var player_score = 0
@onready var label: Label = %Label
@onready var marker_3d: Marker3D = %Marker3D
@onready var marker_3d_2: Marker3D = %Marker3D2
@onready var marker_3d_3: Marker3D = %Marker3D3


const MOB_SPAWNER = preload("uid://cgghe0wean7ng")

func _ready() -> void:
	
	label.text=str("Score :", player_score)
	
	var spawner1= MOB_SPAWNER.instantiate()
	add_child(spawner1)
	spawner1.global_position=marker_3d.global_position
	var spawner2= MOB_SPAWNER.instantiate()
	add_child(spawner2)
	spawner2.global_position=marker_3d_2.global_position
	var spawner3= MOB_SPAWNER.instantiate()
	add_child(spawner3)
	spawner3.global_position=marker_3d_3.global_position
	
	spawner1.mob_spawned.connect(spawn_trigger)
	spawner2.mob_spawned.connect(spawn_trigger)
	spawner3.mob_spawned.connect(spawn_trigger)
	

func spawn_trigger(mob: Variant) -> void:
	mob.mob_died.connect(func on_mob_died(): 
		increase_score()
		puff(mob.global_position)
		)
	puff(mob.global_position)
	
#func _on_mob_spawner_mob_spawned(mob: Variant) -> void:
#	mob.mob_died.connect(increase_score)

func increase_score() :
	player_score+=1
	label.text=str("Score : ", player_score)


func puff(mob_global_position):
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position=mob_global_position
	


func _on_kill_plane_body_entered(_body: Node3D) -> void:
	print("a")
	get_tree().reload_current_scene.call_deferred()
