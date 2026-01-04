extends CharacterBody3D

const CAMERA_X_SENSIBLITY = 0.3
const CAMERA_Y_SENSIBLITY = 0.3
const CAMERA_MAX_ROTATION_Y_UP = 70.0
const CAMERA_MAX_ROTATION_Y_DOWN = -70.0
const CHARACTER_MAX_SPEED = 7.0
const CHARACTER_ACCELERATION = 20.0
const CHARACTER_JUMP_SPEED = 10.0
const GRAVITY_VALUE = 20.0


var player_speed =0.0


func _ready() -> void:
	
	## Hide cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	
	#######################################################
	## mouse rotation handler ##
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * CAMERA_X_SENSIBLITY
		
		## this solution kinda work but allows to go further max range
		#if (%Camera3D.rotation_degrees.x > -60 and event.relative.y > 0) or (%Camera3D.rotation_degrees.x < 60 and event.relative.y < 0):
		#	%Camera3D.rotation_degrees.x -= event.relative.y * CAMERA_Y_SENSIBLITY
		
		## Bit better solution to truncate to max range
		#if (%Camera3D.rotation_degrees.x - event.relative.y * CAMERA_Y_SENSIBLITY < CAMERA_MAX_ROTATION_Y_UP) 
		#and (%Camera3D.rotation_degrees.x - event.relative.y * CAMERA_Y_SENSIBLITY > CAMERA_MAX_ROTATION_Y_DOWN):
		#	%Camera3D.rotation_degrees.x -= event.relative.y * CAMERA_Y_SENSIBLITY
		#elif %Camera3D.rotation_degrees.x - event.relative.y * CAMERA_Y_SENSIBLITY >= CAMERA_MAX_ROTATION_Y_UP :
		#	%Camera3D.rotation_degrees.x = CAMERA_MAX_ROTATION_Y_UP
		#else :
		#	%Camera3D.rotation_degrees.x = CAMERA_MAX_ROTATION_Y_DOWN
		
		## Best solution using built-in method
		%Camera3D.rotation_degrees.x -= event.relative.y * CAMERA_Y_SENSIBLITY
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, CAMERA_MAX_ROTATION_Y_DOWN, CAMERA_MAX_ROTATION_Y_UP)
	
		#print(%Camera3D.rotation_degrees.x)
		
	#######################################################
	## Release mouse appearance on esc press ##
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
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
	
	##trying to implement acceleration
	## little bug when decceleration ends, always move the character slightly on the other axes
	if direction.z != 0:
		player_speed += CHARACTER_ACCELERATION*delta
		player_speed=clamp(player_speed, -CHARACTER_MAX_SPEED, CHARACTER_MAX_SPEED)
		
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
		player_speed=clamp(player_speed, -CHARACTER_MAX_SPEED, CHARACTER_MAX_SPEED)
		
		velocity.x =direction.x * player_speed
		
	elif velocity.x > 0 :
		velocity.x -= CHARACTER_ACCELERATION * delta
		if velocity.x < 0:
			velocity.x=0
	elif velocity.x < 0 :
		velocity.x += CHARACTER_ACCELERATION * delta
		if velocity.x > 0:
			velocity.x=0
			
			
	## Applying gravity
	velocity.y-= GRAVITY_VALUE * delta
	
	## JUMP 
	if Input.is_action_just_pressed("jump"):
		velocity.y = CHARACTER_JUMP_SPEED
	
	
	move_and_slide()
