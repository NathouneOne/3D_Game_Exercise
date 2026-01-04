extends CharacterBody3D

const CAMERA_X_SENSIBLITY = 0.3
const CAMERA_Y_SENSIBLITY = 0.3
const CAMERA_MAX_ROTATION_Y_UP = 70.0
const CAMERA_MAX_ROTATION_Y_DOWN = -70.0
const CHARACTER_MAX_SPEED = 7.0
const CHARACTER_SPRINT_MAX_SPEED = 12.0
const CHARACTER_ACCELERATION = 20.0
const CHARACTER_JUMP_SPEED = 10.0
const GRAVITY_VALUE = 20.0

const FALLING_VALUE_RESET = -10.0

var player_speed =0.0
var character_max_speed=CHARACTER_MAX_SPEED
var jump_count=0


######################################
## TODO 							##
## Add a zoom on right click 		##
######################################



func _ready() -> void:
	
	## Hide cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	
	#######################################################
	## mouse rotation handler ##
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * CAMERA_X_SENSIBLITY
		
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
	if position.y < FALLING_VALUE_RESET :
		position=Vector3(0,1,0)
	
	move_and_slide()
