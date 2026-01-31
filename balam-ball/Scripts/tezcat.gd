extends CharacterBody2D


@export var SPEED = 80.0
@export var limit_up = -51.0
@export var limit_down = 51.0

var direction = 1 


func _physics_process(_delta):
	velocity.y = lerp(velocity.y, direction * SPEED, 0.05)
	velocity.x = 0 
	
	if global_position.y >= limit_down :
		direction = -1 
	elif global_position.y <= limit_up :
		direction = 1 
	move_and_slide()
	
	
	
	
	
	
