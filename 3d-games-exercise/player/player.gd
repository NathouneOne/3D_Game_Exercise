extends CharacterBody3D

const CAMERA_X_SENSIBLITY = 0.3
const CAMERA_Y_SENSIBLITY = 0.3
const CAMERA_MAX_ROTATION_Y_UP = 70.0
const CAMERA_MAX_ROTATION_Y_DOWN = -70.0
const CHARACTER_MAX_SPEED = 7.0



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
	
		print(%Camera3D.rotation_degrees.x)
		
	#######################################################
	## Release mouse appearance on esc press ##
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func _physics_process(_delta: float) -> void:
	#######################################################
	## Player Movement ##
	
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	## convert 2D input direction to 3D
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	
	## convert to relative coordinate to player rotation
	var direction = transform.basis * input_direction_3D
	
	## applying speed separatly to x and z to avoid cancel jump & fall with a *0
	velocity.z = direction.z * CHARACTER_MAX_SPEED
	velocity.x = direction.x * CHARACTER_MAX_SPEED
	
	move_and_slide()
