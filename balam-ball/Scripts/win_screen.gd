extends Control

@onready var record_label = $Record
@onready var mascara = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Suponiendo que guardas el score en un Autoload llamado 'GameManager'
	# record_label.text = "Tu Record: " + str(GameManager.high_score) + " puntos"
	
	# Animación de entrada: la máscara aparece desde arriba
	mascara.position.y = -200
	var tween = create_tween()
	tween.tween_property(mascara, "position:y", 100, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	# Reinicia el juego (escena del tablero)
	TRANSITION.change_scene_to_file("res://Scenes/board.tscn")


func _on_menu_pressed() -> void:
	# Regresa al menú principal
	TRANSITION.change_scene_to_file("res://Scenes/menu.tscn")
