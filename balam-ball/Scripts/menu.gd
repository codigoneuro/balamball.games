extends Control

@onready var musica = $MusicaFondo

func _ready():
	if musica:
		musica.play()
	
	# Verifica que el nombre después de la barra "/" sea el exacto del nodo
	if has_node("VBoxContainer/Jugar"):
		$VBoxContainer/Jugar.pressed.connect(_on_jugar_pressed)
	
	if has_node("VBoxContainer/Salir"):
		$VBoxContainer/Salir.pressed.connect(_on_salir_pressed)

func _on_jugar_pressed():
	# Ahora que la función acepta argumentos, esto no dará error
	TRANSITION.change_scene_to_file("res://Scenes/board.tscn")

func _on_salir_pressed():
	get_tree().quit()
