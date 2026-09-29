extends Label

var total_characters: int = 0
var typing_speed: float = 40
var current_char_count: float = 0.0
var is_typing: bool = false

@onready var back = $Back
@onready var forward = $Forward
@onready var siguiente = $Continue
@onready var block = %Blocker

var faces = []

var guion = []

var cur_index = 0

func _ready() -> void:
	grab_focus()
	faces = [$Abuelo, $Ninan, $Rumi]
	back.disabled = true

func start():
	new_dialogue(guion[cur_index])

func new_dialogue(dialogue):
	var chars = dialogue[0]
	var face_qty = 0
	for face in faces:
		if face.name in chars:
			face.position.y = 115.0 + 115 * (2*face_qty)
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
			is_typing = false
			current_char_count = total_characters
			visible_characters = total_characters
	if ev is InputEventKey and ev.is_pressed():
		if ev.keycode == KEY_RIGHT and cur_index < guion.size()-1:
			next()
		if ev.keycode == KEY_LEFT and cur_index > 0:
			previous()

func next():
	cur_index += 1
	new_dialogue(guion[cur_index])
	if(cur_index == guion.size()-1):
		forward.disabled = true
		siguiente.visible = true
	back.disabled = false
			
	
func previous():
	cur_index -= 1
	new_dialogue(guion[cur_index])
	if(cur_index == 0):
		back.disabled = true
	forward.disabled = false

func _on_forward_pressed() -> void:
	next()


func _on_back_pressed() -> void:
	previous()


func _on_continue_pressed() -> void:
	if Global.tutorial_index in [1, 2, 3, 4]:
		block.visible = false
		queue_free()
	Global.tutorial_index += 1
	print(Global.tutorial_index)
	
