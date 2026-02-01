extends Control

@onready var mascara = $MascaraDerrota
@onready var label_puntos = $LabelPuntos

func _ready():
	# Si tienes los puntos guardados en un Global (Autoload)
	# label_puntos.text = "Tu Record: " + str(Global.puntos) + " puntos"
	
	# Animación de entrada: Pequeño temblor
	aparecer_con_vibracion()

func aparecer_con_vibracion():
	var tween = create_tween()
	# La máscara aparece escalando desde cero con un efecto elástico
	mascara.scale = Vector2.ZERO
	mascara.pivot_offset = mascara.size / 2 # Centramos el pivote para que escale desde el medio
	
	tween.tween_property(mascara, "scale", Vector2.ONE, 0.8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Añadimos un pequeño movimiento de arriba a abajo infinito
	var tween_float = create_tween().set_loops()
	tween_float.tween_property(mascara, "position:y", mascara.position.y + 10, 1.5).set_trans(Tween.TRANS_SINE)
	tween_float.tween_property(mascara, "position:y", mascara.position.y, 1.5).set_trans(Tween.TRANS_SINE)

func _on_btn_reintentar_pressed():
	# Reiniciamos los puntos en tu script global si es necesario
	# Global.puntos = 0 
	TRANSITION.change_scene_to_file("res://Scenes/board.tscn")

func _on_btn_menu_pressed():
	TRANSITION.change_scene_to_file("res://Scenes/menu.tscn")
