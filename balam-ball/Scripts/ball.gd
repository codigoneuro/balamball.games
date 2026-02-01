extends CharacterBody2D

@export var velocidad_inicial = 150.0
@export var incremento_velocidad = 1.05 

var ultimo_jugador: String = ""
var direccion = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	lanzar_pelota()
func lanzar_pelota():
	var x_dir = [-1, 1].pick_random()
	var y_dir = [-0.8, 0.8].pick_random()
	direccion = Vector2(x_dir, y_dir).normalized()
	velocity = direccion * velocidad_inicial

func _physics_process(delta: float) -> void:
	var colision = move_and_collide(velocity * delta)
	if colision:
		var normal = colision.get_normal()
		velocity = velocity.bounce(normal)
		
		global_position += normal * 2.0
		var objeto_tocado = colision.get_collider()
		
		if objeto_tocado:
			# Registramos el último toque basado en el grupo del objeto
			if objeto_tocado.is_in_group("Balam"):
				ultimo_jugador = "Balam"
				velocity *= incremento_velocidad
			elif objeto_tocado.is_in_group("Tezcat"):
				ultimo_jugador = "Tezcat"
				velocity *= incremento_velocidad
			
	
