extends Control

# Referencias a los nodos (Asegúrate de que los nombres sean EXACTOS)
@onready var musica = $MusicaFondo

func _ready():
	# Si la música no suena, verifica que el nodo se llame "MusicaFondo"
	if musica:
		musica.play()
	
	# Conexiones seguras
	if has_node("VBoxContainer/BotonJugar"):
		$VBoxContainer/Jugar.pressed.connect(_on_jugar_pressed)
	if has_node("VBoxContainer/BotonOpciones"):
		$VBoxContainer/Salir.pressed.connect(_on_salir_pressed)

func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://Scenes/board.tscn")

func _on_salir_pressed():
	get_tree().quit()
