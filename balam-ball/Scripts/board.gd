extends Node2D

#  Ya no necesitamos las variables locales de puntos aquí
# porque usaremos las de GameManager.

@onready var pelota = $Ball 
var escena_win = preload("res://Scenes/win_screen.tscn")
var escena_game_over = preload("res://Scenes/game_over_screen.tscn")

func _ready():
	# Conexión de señales existentes 
	$PorteriaBalam.body_entered.connect(_on_gol_contra_balam) 
	$PorteriaTezcat.body_entered.connect(_on_gol_contra_tezcat) 
	$AroSuperior.body_entered.connect(_on_aro_anotado) 
	$AroInferior.body_entered.connect(_on_aro_anotado)
	
	# ACTUALIZACIÓN: Leer los puntos al iniciar/recargar la escena 
	actualizar_interfaz()

func actualizar_interfaz():
	# Accedemos a los puntos globales para que no se pierdan al reiniciar 
	$LabelBalam.text = str(GameManager.puntos_balam)
	$LabelTezcat.text = str(GameManager.puntos_tezcat)

# --- PUNTAJE NORMAL ---
func _on_gol_contra_balam(body):
	if body.name == "Ball": 
		GameManager.puntos_tezcat += 1 
		# Disparamos el parpadeo
		$AnimationPlayer.play("anotacion_tezcat")
		# Esperamos a que la animación termine antes de reiniciar
		await $AnimationPlayer.animation_finished
		verificar_puntos() 

func _on_gol_contra_tezcat(body):
	if body.name == "Ball": 
		GameManager.puntos_balam += 1 
		# Disparamos el parpadeo
		$AnimationPlayer.play("anotacion_balam")
		# Esperamos a que la animación termine antes de reiniciar
		await $AnimationPlayer.animation_finished
		verificar_puntos()

# --- VICTORIA SÚBITA ---
func _on_aro_anotado(body):
	if body.name == "Ball": 
		var anotador = body.ultimo_jugador # 
		if anotador != "": 
			Engine.time_scale = 0.2
			await get_tree().create_timer(0.5).timeout
			Engine.time_scale = 1.0
			finalizar_juego(anotador, true)

# --- CONTROL DE PARTIDA ---
# En board.gd
func verificar_puntos():
	# Verificamos los puntos usando el Autoload GameManager [cite: 6]
	if GameManager.puntos_balam >= GameManager.META_PUNTOS:
		finalizar_juego("Balam", false) 
	elif GameManager.puntos_tezcat >= GameManager.META_PUNTOS:
		finalizar_juego("Tezcat", false) 
	else:
		# Reiniciamos la escena para resetear la física de la pelota 
		get_tree().reload_current_scene()

func finalizar_juego(ganador, es_subita):
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.stop() 
	
	# 1. Pausamos el juego
	get_tree().paused = true 
	
	var pantalla
	if ganador == "Balam":
		pantalla = escena_win.instantiate()
	else:
		pantalla = escena_game_over.instantiate()
		
	# 2. Creamos un contenedor que obligue a la pantalla a estar al frente
	var capa_ui = CanvasLayer.new()
	capa_ui.layer = 100 # Prioridad máxima
	add_child(capa_ui)
	
	# 3. Añadimos la pantalla de victoria/derrota a esa capa
	capa_ui.add_child(pantalla)
