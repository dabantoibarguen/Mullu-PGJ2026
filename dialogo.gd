extends Label

var total_characters: int = 0
var typing_speed: float = 40
var current_char_count: float = 0.0
var is_typing: bool = false

@onready var back = $Back
@onready var forward = $Forward
@onready var siguiente = $Continue

var faces = []

var guion = [
  [["Ninan"], "¡Rumi! Tienes que seguirme. El abuelo acaba de regresar del mar, pero parece que se encontró con algo y está herido."],
  [["Rumi"], "Eso no es posible. Nuestro abuelo es el mejor pescador, es imposible que algo le haya pasa…"],
  [["Ninan"], "No hay tiempo para esto Rumi ¡tenemos que ir!"],
  [["Ninan", "Rumi"], "¡ABUELO! ¡TU BRAZO ESTÁ HERIDO! ¿QUÉ PASÓ?"],
  [["Abuelo"], "Queridos nietos. No se preocupen, todo está bien. Les contaré mi historia… Estaba pescando en el mar y estaba ya bastante adentro, cuando el agua empieza a oscurecer. Entonces el viento empezó a soplar con fuerza y vi como varias aves se dirigían a la costa y los peces se resguardaban en las profundidades. Entonces supe que se avecinaba una tormenta. Pensé en regresar, pero entonces vi a la distancia una isla que no conocía. Cometí el error de ir a explorarla e ignoré las señales."],
  [["Rumi"], "Abuelo, tu siempre nos dices que debemos tener cuidado con el mar. ¿Por qué no te fuiste?"],
  [["Abuelo"], "Fui arrogante. Pensé que tendría el tiempo y la habilidad de salirme con la mía. Al llegar pude ver un pez enorme, como ningún otro, pero en ese instante la tormenta se desató. Intenté regresar pero el oleaje era muy fuerte. Una de las olas arremetió contra el remo y así fue como me hice estas heridas."],
  [["Ninan"], "Ese pez, ¿qué tan grande era?"],
  [["Abuelo"], "Más grande que un totora. Pero eso no importa ahora, cuando me recupere iré a buscarlo. Hasta entonces, ustedes deberán hacerse cargo de la pesca."],
  [["Rumi"], "No te preocupes abuelo, nosotros nos haremos cargo. No te defraudaremos."]
]

var cur_index = 0

func _ready() -> void:
	faces = [$Abuelo, $Ninan, $Rumi]
	new_dialogue(guion[cur_index])
	back.disabled = true


func new_dialogue(dialogue):
	var chars = dialogue[0]
	var face_qty = 0
	for face in faces:
		if face.name in chars:
			face.position.y = 119.0 + 119 * (2*face_qty)
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
	Global.tutorial_index += 1
	queue_free()
