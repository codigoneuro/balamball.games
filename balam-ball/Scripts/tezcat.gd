extends CharacterBody2D

@export var SPEED = 150.0 # Un poco más rápido para seguir la bola
@export var limit_up = -51.0
@export var limit_down = 51.0

# Referencia a la pelota (asegúrate de que el nombre coincida en tu escena board)
@onready var pelota = get_parent().get_node("Ball") 

func _physics_process(_delta):
	if pelota:
		# Calculamos la dirección hacia donde está la pelota
		if pelota.global_position.y > global_position.y:
			velocity.y = lerp(velocity.y, SPEED, 0.1)
		else:
			velocity.y = lerp(velocity.y, -SPEED, 0.1)
	
	# Mantener límites y evitar movimiento en X
	velocity.x = 0 
	global_position.y = clamp(global_position.y, limit_up, limit_down)
	
	move_and_slide()
	
	
	
	
