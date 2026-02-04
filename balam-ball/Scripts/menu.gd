extends Control

@onready var musica = $MusicaFondo

func _ready():
	if musica:
		musica.play()

func _on_jugar_pressed():
	TRANSITION.change_scene_to_file("res://Scenes/board.tscn")

func _on_salir_pressed():
	get_tree().quit()


func _on_creditos_pressed() -> void:
	TRANSITION.change_scene_to_file("res://Scenes/credits_screen.tscn")
