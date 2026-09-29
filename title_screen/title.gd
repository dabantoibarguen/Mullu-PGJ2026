extends Node2D


func _on_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($BGM_Main, "volume_db", -20.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://ciudad/ciudad.tscn")
