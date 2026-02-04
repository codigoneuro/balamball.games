extends Node2D

@onready var pelota = $Ball 
@onready var score_sound = $ScorePoint
var escena_win = preload("res://Scenes/win_screen.tscn")
var escena_game_over = preload("res://Scenes/game_over_screen.tscn")
var escena_sudden = preload("res://Scenes/sudden_death_screen.tscn")

func _ready():
	$PorteriaBalam.body_entered.connect(_on_gol_contra_balam) 
	$PorteriaTezcat.body_entered.connect(_on_gol_contra_tezcat) 
	$AroSuperior.body_entered.connect(_on_aro_anotado) 
	$AroInferior.body_entered.connect(_on_aro_anotado)
	actualizar_interfaz()

func actualizar_interfaz():
	$LabelBalam.text = str(GameManager.puntos_balam)
	$LabelTezcat.text = str(GameManager.puntos_tezcat)

# --- PUNTAJE NORMAL ---
func _on_gol_contra_balam(body):
	if body.name == "Ball": 
		GameManager.puntos_tezcat += 1 
		
		# 1. ACTUALIZAR INTERFAZ PRIMERO
		actualizar_interfaz() 
		
		# 2. DISPARAR SONIDO (Sin condiciones extras para asegurar ejecución)
		AudioManager.play_score_sound()
		
		# 3. EFECTO VISUAL
		#$AnimationPlayer.play("anotacion_tezcat") 
		
		# 4. ESPERA PARA REINICIAR (Esto permite que el sonido respire)
		#await $AnimationPlayer.animation_finished 
		verificar_puntos() 

func _on_gol_contra_tezcat(body):
	if body.name == "Ball": 
		GameManager.puntos_balam += 1 
		
		actualizar_interfaz() 
		AudioManager.play_score_sound()
		#$AnimationPlayer.play("anotacion_balam") 
		
		#await $AnimationPlayer.animation_finished 
		verificar_puntos()

# --- VICTORIA SÚBITA ---
func _on_aro_anotado(body):
	if body.name == "Ball": 
		var anotador = body.ultimo_jugador 
		if anotador != "": 
			# Sonido de punto también en el aro 
			if has_node("ScorePoint"): AudioManager.play_score_sound()
			Engine.time_scale = 0.2
			await get_tree().create_timer(0.5).timeout
			Engine.time_scale = 1.0
			finalizar_juego(anotador, true)

func verificar_puntos():
	# Verificamos los puntos usando el Autoload GameManager 
	if GameManager.puntos_balam >= GameManager.META_PUNTOS:
		finalizar_juego("Balam", false) 
	elif GameManager.puntos_tezcat >= GameManager.META_PUNTOS:
		finalizar_juego("Tezcat", false) 
	else:
		# CAMBIO AQUÍ: Usamos call_deferred para evitar el error de Physics Callback
		get_tree().call_deferred("reload_current_scene")

func finalizar_juego(ganador, es_subita):
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.stop() 
	
	get_tree().paused = true 
	var pantalla

	if es_subita:
		pantalla = escena_sudden.instantiate()
		# Validación de mensajes para Muerte Súbita
		if ganador == "Balam":
			if pantalla.has_method("configurar_pantalla"):
				pantalla.configurar_pantalla("Victory")
		else:
			if pantalla.has_method("configurar_pantalla"):
				pantalla.configurar_pantalla("Game Over")
	else:
		if ganador == "Balam":
			pantalla = escena_win.instantiate()
			if pantalla.has_method("establecer_ganador"):
				pantalla.establecer_ganador(GameManager.puntos_balam) 
		else:
			pantalla = escena_game_over.instantiate()
		
	add_child.call_deferred(pantalla)
