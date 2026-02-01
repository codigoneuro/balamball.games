extends CharacterBody2D

@export var velocidad_inicial = 150.0
@export var incremento_velocidad = 1.05 

var ultimo_jugador: String = ""
var direccion = Vector2.ZERO

func _ready() -> void:
	# Reset inicial al cargar la escena tras un gol
	velocity = Vector2.ZERO 
	# Tiempo de espera para que el jugador se prepare
	await get_tree().create_timer(1.0).timeout 
	lanzar_pelota()

func lanzar_pelota():
	velocity = Vector2.ZERO 
	ultimo_jugador = "" 
	
	# Pausa breve para estabilidad física
	await get_tree().create_timer(0.2).timeout 
	
	var x_dir = [-1, 1].pick_random()
	var y_dir = [-0.8, 0.8].pick_random()
	direccion = Vector2(x_dir, y_dir).normalized()
	velocity = direccion * velocidad_inicial 

func _physics_process(delta: float) -> void:
	var colision = move_and_collide(velocity * delta) 
	if colision:
		var normal = colision.get_normal() 
		velocity = velocity.bounce(normal) 
		
		# Evita que la pelota se quede pegada
		global_position += normal * 2.0 
		
		var objeto_tocado = colision.get_collider() 
		if objeto_tocado: 
			if objeto_tocado.is_in_group("Balam"): 
				ultimo_jugador = "Balam" 
				velocity *= incremento_velocidad 
				
				#$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.2)
				#$AudioStreamPlayer2D.play()
				
			elif objeto_tocado.is_in_group("Tezcat"): 
				ultimo_jugador = "Tezcat" 
				velocity *= incremento_velocidad
			# REPRODUCIR SONIDO:
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.2)
			$AudioStreamPlayer2D.play()
			print("¡Golpe de jugador detectado!")
	
