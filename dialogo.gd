extends Label

var total_characters: int = 0
var typing_speed: float = 50
var current_char_count: float = 0.0
var is_typing: bool = false

@onready var back = $Back
@onready var forward = $Forward
@onready var siguiente = $Continue
@onready var block = %Blocker

var faces = []
var guion = []

var mode = ""

var cur_index = 0

func _ready() -> void:
	grab_focus()
	faces = [$Abuelo, $Laia, $Mitso]

func start():
	if guion == [] or guion.size() == 0:
		get_parent().queue_free()
	if guion != []:
		new_dialogue(guion[cur_index])
		forward.disabled = false
	if guion.size() <= 1:
		horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		forward.disabled = true
		siguiente.visible = true
		if mode == "Resumen":
			typing_speed = 80
			siguiente.text = "Cerrar"
		elif mode == "Resumen Final":
			typing_speed = 65
			siguiente.text = "Volver al pueblo"
		elif mode == "Game Over":
			typing_speed = 65
			siguiente.text = "Intenta otra vez"

func new_dialogue(dialogue):
	var chars = dialogue[0]
	var face_qty = 0
	for face in faces:
		if face.name in chars:
			face.position.y = 131.0 + 131 * (2*face_qty)
			face.visible = true
			face_qty += 1
		else:
			face.visible=false
	var txt = dialogue[1]
	text = txt
	total_characters = txt.length()
	is_typing = true
	current_char_count = 0.0
	visible_characters = 0

func _process(delta: float) -> void:
	if is_typing and visible_characters < total_characters:
		if text[visible_characters] in [".", ",", "¡", "¿"]:
			await get_tree().create_timer(0.4).timeout
		current_char_count += typing_speed * delta
		visible_characters = int(current_char_count)
		if visible_characters >= total_characters:
			is_typing = false

func _input(ev: InputEvent) -> void:
	if ev is InputEventMouse and ev.is_pressed():
		if ev.button_mask == MOUSE_BUTTON_RIGHT:
			skip_ahead()
	if ev is InputEventKey and ev.is_pressed():
		if (ev.keycode in [KEY_RIGHT, KEY_SPACE, KEY_ENTER]) and cur_index < guion.size():
			if cur_index < guion.size() -1:
				get_viewport().set_input_as_handled() # Para que no marque un boton accidentalmente
				next()
			else:
				skip_ahead()
		if ev.keycode in [KEY_LEFT, KEY_BACKSPACE, KEY_BACK] and cur_index > 0:
			get_viewport().set_input_as_handled()
			previous()
		if ev.keycode == KEY_ESCAPE and (siguiente.visible):
			get_viewport().set_input_as_handled()
			close_window()

func skip_ahead():
	is_typing = false
	current_char_count = total_characters
	visible_characters = total_characters

func next():
	cur_index += 1
	if cur_index < guion.size():
		new_dialogue(guion[cur_index])
		if(cur_index == guion.size()-1):
			forward.disabled = true
			siguiente.visible = true
		back.disabled = false
	else:
		cur_index == guion.size()-1
			
	
func previous():
	cur_index -= 1
	if cur_index >= 0:
		new_dialogue(guion[cur_index])
		if(cur_index == 0):
			back.disabled = true
		forward.disabled = false
	else:
		cur_index = 0

func _on_forward_pressed() -> void:
	next()

func _on_back_pressed() -> void:
	previous()

func close_window():
	if mode == "Resumen":
		get_parent().queue_free()
	elif mode == "Resumen Final":
		get_parent().queue_free()
		get_tree().change_scene_to_file("res://ciudad/ciudad.tscn")
	elif mode == "Game Over":
		get_parent().queue_free()
		get_tree().reload_current_scene()
	elif Global.tutorial:		
		block.visible = false
		get_parent().queue_free()
		Global.tutorial_index += 1
		print(Global.tutorial_index)
	
func _on_continue_pressed() -> void:
	close_window()
