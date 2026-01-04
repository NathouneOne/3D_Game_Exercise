extends CharacterBody3D

const X_SENSIBLITY = 0.3
const Y_SENSIBLITY = 0.3
const CAMERA_MAX_ROTATION_Y_UP = 70.0
const CAMERA_MAX_ROTATION_Y_DOWN = -70.0



func _ready() -> void:
	
	## Hide cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	
	#######################################################
	## mouse rotation handler ##
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * X_SENSIBLITY
		
		## this solution kinda work but allows to go further 60
		#if (%Camera3D.rotation_degrees.x > -60 and event.relative.y > 0) or (%Camera3D.rotation_degrees.x < 60 and event.relative.y < 0):
		#	%Camera3D.rotation_degrees.x -= event.relative.y * Y_SENSIBLITY
		
		## Better solution to truncate to 60 ?
		#if (%Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY < CAMERA_MAX_ROTATION_Y_UP) and (%Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY > CAMERA_MAX_ROTATION_Y_DOWN):
		#	%Camera3D.rotation_degrees.x -= event.relative.y * Y_SENSIBLITY
		#elif %Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY >= CAMERA_MAX_ROTATION_Y_UP :
		#	%Camera3D.rotation_degrees.x = CAMERA_MAX_ROTATION_Y_UP
		#else :
		#	%Camera3D.rotation_degrees.x = CAMERA_MAX_ROTATION_Y_DOWN
		
		## Best solution
		%Camera3D.rotation_degrees.x -= event.relative.y * Y_SENSIBLITY
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, CAMERA_MAX_ROTATION_Y_DOWN, CAMERA_MAX_ROTATION_Y_UP)
	
		print(%Camera3D.rotation_degrees.x)
		
	#######################################################
	## Release mouse appearance on esc press ##
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	
	
