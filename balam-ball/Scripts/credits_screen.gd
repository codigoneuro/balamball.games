extends Control

# Usamos la ruta completa si es necesario
@onready var mascara = $Mascara  # <--- Revisa que se llame así en el árbol
@onready var contenedor_texto = $VBoxContainer 

func _ready():
	# Comprobamos si el nodo existe antes de tocar 'modulate'
	if contenedor_texto != null:
		contenedor_texto.modulate.a = 0
		var tween_text = create_tween()
		tween_text.tween_property(contenedor_texto, "modulate:a", 1.0, 1.5)
	else:
		print("ERROR: No se encontró el nodo del texto. Revisa el nombre en el árbol.")

	if mascara:
		animar_mascara_flotante()

func animar_mascara_flotante():
	var tween = create_tween().set_loops()
	# Usamos property_setup para evitar errores si la máscara se mueve
	var final_y = mascara.position.y - 20
	var original_y = mascara.position.y
	
	tween.tween_property(mascara, "position:y", final_y, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(mascara, "position:y", original_y, 2.0).set_trans(Tween.TRANS_SINE)


func _on_regresar_pressed() -> void:
	TRANSITION.change_scene_to_file("res://Scenes/menu.tscn")
