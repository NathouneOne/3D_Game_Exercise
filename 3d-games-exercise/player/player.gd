extends CharacterBody3D

const CAMERA_X_SENSIBLITY = 0.25
const CAMERA_Y_SENSIBLITY = 0.25
const CAMERA_MAX_ROTATION_Y_UP = 70.0
const CAMERA_MAX_ROTATION_Y_DOWN = -70.0
const CHARACTER_MAX_SPEED = 7.0
const CHARACTER_SPRINT_MAX_SPEED = 12.0
const CHARACTER_ACCELERATION = 20.0
const CHARACTER_JUMP_SPEED = 10.0
const GRAVITY_VALUE = 20.0

const FALLING_VALUE_RESET = -10.0

const FOV_ORIGINAL = 75.0
const FOV_ZOOM = 35.0
const ZOOM_SPEED = 300.0

const CAMERA_ZOOM_X_SENSIBILITY=0.1
const CAMERA_ZOOM_Y_SENSIBILITY=0.1

var player_speed =0.0
var character_max_speed=CHARACTER_MAX_SPEED
var jump_count=0

var fov=FOV_ORIGINAL
var camera_x_sensibility=CAMERA_X_SENSIBLITY
var camera_y_sensibility=CAMERA_Y_SENSIBLITY




func _ready() -> void:
	
	## Hide cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	
	#######################################################
	## mouse rotation handler ##
	if event is InputEventMouseMotion:
		if fov == FOV_ZOOM:
			camera_x_sensibility=CAMERA_ZOOM_X_SENSIBILITY
			camera_y_sensibility=CAMERA_ZOOM_Y_SENSIBILITY
		else:
			camera_x_sensibility=CAMERA_X_SENSIBLITY
			camera_y_sensibility=CAMERA_Y_SENSIBLITY
			
		rotation_degrees.y -= event.relative.x * camera_x_sensibility
		
		%Camera3D.rotation_degrees.x -= event.relative.y * camera_y_sensibility
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, CAMERA_MAX_ROTATION_Y_DOWN, CAMERA_MAX_ROTATION_Y_UP)
	
		#print(%Camera3D.rotation_degrees.x)
		
	## Release mouse appearance on esc press ##
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func shoot_bullet():
	const BULLET_3D = preload("uid://d4d0fwuexdf7a")
	var new_bullet=BULLET_3D.instantiate()
	%Marker3D.add_child(new_bullet)
	
	new_bullet.global_transform=%Marker3D.global_transform
	
	%Timer.start()
	%AudioStreamPlayer.play()


func _physics_process(delta: float) -> void:
	#######################################################
	## Player Movement ##
	
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	## convert 2D input direction to 3D
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	
	## convert to relative coordinate to player rotation
	var direction = transform.basis * input_direction_3D
	
	## applying speed separatly to x and z to avoid cancel jump & fall with a *0
	#velocity.z = direction.z * CHARACTER_MAX_SPEED
	#velocity.x = direction.x * CHARACTER_MAX_SPEED
	
	
	## no control while jumping hihi
	if is_on_floor():
		jump_count=0
		
		## sprint handler
		if Input.is_action_pressed("sprint"):
			character_max_speed=CHARACTER_SPRINT_MAX_SPEED
		else :
			character_max_speed=CHARACTER_MAX_SPEED
			
			
		##trying to implement acceleration
		## little bug when decceleration ends, ofently move the character slightly on the other axes
		## guess its form the clamp which wouldn't occur at the exact same time on each axes or something like that ? dunno
		if direction.z != 0:
			player_speed += CHARACTER_ACCELERATION*delta
			player_speed=clamp(player_speed, -character_max_speed, character_max_speed)
			velocity.z =direction.z * player_speed
			
		elif velocity.z > 0 :
			velocity.z -= CHARACTER_ACCELERATION * delta
			if velocity.z < 0:
				velocity.z=0
		elif velocity.z < 0 :
			velocity.z += CHARACTER_ACCELERATION * delta
			if velocity.z > 0:
				velocity.z=0
				
		if direction.x != 0:
			player_speed += CHARACTER_ACCELERATION*delta
			player_speed=clamp(player_speed, -character_max_speed, character_max_speed)
			
			velocity.x =direction.x * player_speed
			
		elif velocity.x > 0 :
			velocity.x -= CHARACTER_ACCELERATION * delta
			if velocity.x < 0:
				velocity.x=0
		elif velocity.x < 0 :
			velocity.x += CHARACTER_ACCELERATION * delta
			if velocity.x > 0:
				velocity.x=0
			
		## JUMP 
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		velocity.y = CHARACTER_JUMP_SPEED
		jump_count+=1
			
	## Applying gravity
	velocity.y-= GRAVITY_VALUE * delta
	
	## reset position at start if falling
	## Eventually done with "killing plane" in game.gd
	#if position.y < FALLING_VALUE_RESET :
	#	position=Vector3(0,1,0)
	
	move_and_slide()
	
	
	
	##################################################
	## Shooting input ##
	if Input.is_action_pressed("shoot") and %Timer.is_stopped():
		shoot_bullet()
	
	##################################################
	## Zoom on right click ##
	if Input.is_action_pressed("zoom") :
		fov-=ZOOM_SPEED*delta
	else :
		fov+=ZOOM_SPEED*delta
	fov=clamp(fov, FOV_ZOOM, FOV_ORIGINAL)
	%Camera3D.set_fov(fov)
