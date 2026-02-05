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
		var objeto_tocado = colision.get_collider() 
		
		velocity = velocity.bounce(normal) 
		
		# --- SOLUCIÓN AL BUCLE INFINITO ---
		# Si el rebote es muy recto (vertical u horizontal), añadimos una desviación
		if abs(normal.y) > 0.9 or abs(normal.x) > 0.9:
			var desviacion = randf_range(-15.0, 15.0) # Pequeño ángulo en grados
			velocity = velocity.rotated(deg_to_rad(desviacion))
		
		# Separación dinámica para evitar que se pegue
		var factor_separacion = 5.0 if abs(normal.x) > 0.5 else 2.0
		global_position += normal * factor_separacion
		
		if objeto_tocado: 
			if objeto_tocado.is_in_group("Balam") or objeto_tocado.is_in_group("Tezcat"):
				ultimo_jugador = "Balam" if objeto_tocado.is_in_group("Balam") else "Tezcat"
				velocity *= incremento_velocidad 
				
				# Forzar salida hacia el campo contrario
				if objeto_tocado.is_in_group("Balam"):
					velocity.x = abs(velocity.x) 
				else:
					velocity.x = -abs(velocity.x)

			# Sonido de rebote
			if has_node("AudioStreamPlayer2D"):
				$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.2)
				$AudioStreamPlayer2D.play()
