extends Label

var action = ""

func _ready() -> void:
	var center = get_viewport().get_camera_2d().get_screen_center_position()
	global_position =  center - size/2 - Vector2(0, 25)
	text += action + "?"


func _on_yes_pressed() -> void:
	if action == "pescar":
		get_tree().change_scene_to_file("res://pesca/pesca_main.tscn")
	if action == "bucear":
		get_tree().change_scene_to_file("res://buceo/buceo.tscn")


func _on_no_pressed() -> void:
	get_parent().standby = false
	queue_free()
