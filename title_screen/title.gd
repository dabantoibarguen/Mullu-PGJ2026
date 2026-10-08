extends Node2D


func start_game():
	var tween = create_tween()
	tween.tween_property($BGM_Main, "volume_db", -20.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://ciudad/ciudad.tscn")

func _on_button_pressed() -> void:
	start_game()

func _input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.is_pressed:
		if ev.keycode in [KEY_SPACE, KEY_ENTER]:
			start_game()
