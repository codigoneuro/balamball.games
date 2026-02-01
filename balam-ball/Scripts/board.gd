extends Node2D

#  Ya no necesitamos las variables locales de puntos aquí
# porque usaremos las de GameManager.

@onready var pelota = $Ball 

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
	# [cite: 7, 8] Lógica de fin de juego igual
	var mensaje = "¡VICTORIA SÚBITA! " + ganador if es_subita else "¡GANADOR! " + ganador
	print(mensaje)
	get_tree().paused = true # [cite: 8]
