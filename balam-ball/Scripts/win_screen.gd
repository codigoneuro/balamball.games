extends Control

@onready var record_label = $Record
@onready var mascara = $TextureRect

# Called when the node enters the scene tree for the first time

# Asegúrate de que estos nombres coincidan EXACTAMENTE con tu panel de Escena


func _ready() -> void:
	# 1. ACTUALIZAR EL PUNTAJE
	# Usamos el GameManager para traer el record global
	if record_label:
		record_label.text = "Tu Record: " + str(GameManager.puntos_balam) + " puntos"
	
	# 2. ANIMACIÓN DE LA MÁSCARA
	if mascara:
		# Guardamos la posición donde pusiste la máscara en el editor
		var posicion_final = mascara.position.y
		
		# La ponemos un poco más arriba para que "caiga" al iniciar
		mascara.position.y -= 100 
		mascara.modulate.a = 0 # Empezamos invisible
		
		var tween = create_tween().set_parallel(true) # Animamos posición y opacidad a la vez
		
		# Movimiento de caída suave
		tween.tween_property(mascara, "position:y", posicion_final, 1.2)\
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
			
		# Aparecer suavemente (Fade in)
		tween.tween_property(mascara, "modulate:a", 1.0, 0.8)
	else:
		print("Error: No se encontró el nodo de la máscara. Revisa el nombre en el panel Escena.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	GameManager.puntos_balam = 0
	GameManager.puntos_tezcat = 0
	get_tree().paused = false # ¡No olvides despausar!
	TRANSITION.change_scene_to_file("res://Scenes/board.tscn")



func _on_menu_pressed() -> void:
	# Regresa al menú principal
	TRANSITION.change_scene_to_file("res://Scenes/menu.tscn")
