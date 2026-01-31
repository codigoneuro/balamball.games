extends Node2D

var puntos_balam = 0
var puntos_tezcat = 0
const META_PUNTOS = 7

# Referencia al nodo de la pelota para poder moverla
@onready var pelota = $Ball

func _ready():
	# Conexión de señales de las porterías
	$PorteriaBalam.body_entered.connect(_on_gol_contra_balam)
	$PorteriaTezcat.body_entered.connect(_on_gol_contra_tezcat)
	
	# Conexión de señales de los aros
	$AroSuperior.body_entered.connect(_on_aro_anotado)
	$AroInferior.body_entered.connect(_on_aro_anotado)
	
# --- PUNTAJE NORMAL ---
func _on_gol_contra_balam(body):
	if body.name == "Ball":
		puntos_tezcat += 1
		print("Punto para Tezcat! Marcador: ", puntos_balam, "-", puntos_tezcat)
		verificar_puntos()

func _on_gol_contra_tezcat(body):
	if body.name == "Ball":
		puntos_balam += 1
		print("Punto para Balam! Marcador: ", puntos_balam, "-", puntos_tezcat)
		verificar_puntos()
		
# --- VICTORIA SÚBITA ---
func _on_aro_anotado(body):
	if body.name == "Ball":
		# Usamos la variable definida en ball.gd 
		var anotador = body.ultimo_jugador 
		if anotador != "":
			finalizar_juego(anotador, true)

# --- CONTROL DE PARTIDA ---
func verificar_puntos():
	if puntos_balam >= META_PUNTOS:
		finalizar_juego("Balam", false)
	elif puntos_tezcat >= META_PUNTOS:
		finalizar_juego("Tezcat", false)
	else:
		reiniciar_posicion_pelota()

func reiniciar_posicion_pelota():
	# Detenemos la pelota momentáneamente
	pelota.velocity = Vector2.ZERO
	# La centramos en la pantalla (ajusta 320x180 según tu centro)
	pelota.global_position = Vector2(320, 180) 
	# Llamamos a la función de lanzamiento del script ball.gd 
	pelota.lanzar_pelota()
	
func finalizar_juego(ganador, es_subita):
	var mensaje = ""
	if es_subita:
		mensaje = "¡VICTORIA SÚBITA! " + ganador + " ha encestado en el Aro Sagrado."
	else:
		mensaje = "¡FIN DEL JUEGO! " + ganador + " es el ganador con 7 puntos."
	
	print(mensaje)
	
	# Detener el tiempo del juego por completo
	get_tree().paused = true
	# Aquí podrías activar un nodo CanvasLayer con un Label para mostrar el mensaje
