extends Node

# Nodo para el sonido de puntos
var score_player : AudioStreamPlayer

func _ready():
	# Creamos el reproductor de audio dinámicamente
	score_player = AudioStreamPlayer.new()
	add_child(score_player)
	
	# Cargamos el sonido (ajusta la ruta a tu archivo real)
	score_player.stream = load("res://music/score.wav")
	
	# IMPORTANTE: Para que suene siempre, incluso en pausas
	score_player.process_mode = Node.PROCESS_MODE_ALWAYS

func play_score_sound():
	if score_player.stream:
		score_player.play()
