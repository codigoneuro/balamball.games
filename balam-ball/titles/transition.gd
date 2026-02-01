extends CanvasLayer

@onready var rect = $ColorRect # Asegúrate de que este sea el nombre de tu ColorRect

func change_scene_to_file(target_scene: String) -> void:
	print("1. Iniciando transición...")
	layer = 100 # Nos aseguramos de estar por encima de todo
	
	# Preparamos el Rect (Invisible pero activo)
	rect.visible = true
	rect.modulate.a = 0.0
	
	# --- FADE OUT (Hacia negro) ---
	var tween_in = create_tween()
	# Cambiamos 0.5 por 1.5 si lo quieres MUCHO más lento
	tween_in.tween_property(rect, "modulate:a", 1.0, 0.0).set_trans(Tween.TRANS_SINE)
	
	await tween_in.finished
	print("2. Pantalla en negro. Cambiando escena...")
	
	# Cambiamos la escena
	get_tree().change_scene_to_file(target_scene)
	
	# PAUSA TÁCTICA: Nos quedamos en negro un instante para que no sea brusco
	await get_tree().create_timer(0.5).timeout 
	
	# --- FADE IN (Hacia la nueva escena) ---
	var tween_out = create_tween()
	tween_out.tween_property(rect, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE)
	
	await tween_out.finished
	rect.visible = false # Lo ocultamos al final para no molestar
	layer = -1
	print("3. Transición terminada.")
