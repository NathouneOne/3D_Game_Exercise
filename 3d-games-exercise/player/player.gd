extends CharacterBody3D

const X_SENSIBLITY = 0.3
const Y_SENSIBLITY = 0.3



func _unhandled_input(event: InputEvent) -> void:
	
	
	#######################################################
	## mouse handle
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * X_SENSIBLITY
		
		## this solution kinda work but allows to go further 60
		#if (%Camera3D.rotation_degrees.x > -60 and event.relative.y > 0) or (%Camera3D.rotation_degrees.x < 60 and event.relative.y < 0):
		#	%Camera3D.rotation_degrees.x -= event.relative.y * Y_SENSIBLITY
		
		## Better solution to truncate to 60 ?
		if (%Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY < 60) and (%Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY > -60):
			%Camera3D.rotation_degrees.x -= event.relative.y * Y_SENSIBLITY
		elif %Camera3D.rotation_degrees.x - event.relative.y * Y_SENSIBLITY >= 60 :
			%Camera3D.rotation_degrees.x = 60
		else :
			%Camera3D.rotation_degrees.x = -60
		#print(%Camera3D.rotation_degrees.x)
	
	
	
	######################################################
	
