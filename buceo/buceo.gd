extends Node2D

@onready var blur = $AaronBlur
@onready var snipSnap = $AaronBlur/SnipGame
@onready var buceador = %Buceador

func _ready() -> void:
	pass
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventKey:
		if ev.is_pressed() and ev.keycode == KEY_SPACE:
			blur.visible = true
			snipSnap.global_position = get_viewport().get_camera_2d().get_screen_center_position()
			buceador.playing = true
			snipSnap.start()
		elif ev.is_pressed() and ev.keycode == KEY_E:
			get_tree().change_scene_to_file("res://navegacion/navegacion.tscn")
			
func end_snip(result = false):
	print(result)
	blur.visible = false
	buceador.playing = false
