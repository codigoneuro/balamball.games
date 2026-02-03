extends CharacterBody2D

@export var speed = 150.0

func get_input():
	var input_direction = Input.get_axis("up", "down")
	velocity.y = input_direction * speed
	velocity.x = 0

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
