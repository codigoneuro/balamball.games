extends CanvasLayer

@onready var record_label = $Record
@onready var mascara = $TextureRect

func _ready() -> void:
	# Animación de entrada: la máscara aparece desde arriba 
	mascara.position.y = -100
	var tween = create_tween()
	tween.tween_property(mascara, "position:y", 100, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _on_retry_pressed() -> void:
	# Reiniciar los puntos en el GameManager
	GameManager.puntos_balam = 0
	GameManager.puntos_tezcat = 0
	
	# Quitar la pausa del juego para que los nodos puedan moverse 
	get_tree().paused = false
	
	# Reiniciar la escena del tablero 
	
	get_tree().change_scene_to_file("res://Scenes/board.tscn")

func _on_menu_pressed() -> void:
	# Reiniciar puntos también al ir al menú
	GameManager.puntos_balam = 0
	GameManager.puntos_tezcat = 0
	
	# Quitar la pausa antes de cambiar de escena 
	get_tree().paused = false
	
	# Regresar al menú principal 
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
