extends CanvasLayer

@onready var templo = $Templo
@onready var tienda = $Tienda
@onready var abuelo = $Abuelo
@onready var textBox = $MainText
@onready var blur = $AaronBlur

func _ready() -> void:
	if Global.tutorial:
		$BGM_Main.stop()
		var tween = create_tween()
		$AbueloHerido.play()
		tween.tween_property($AbueloHerido, "volume_db", -8.0, 0.5)
		textBox.visible = false
		var dialogue = Global.dialogo.instantiate()
		add_child(dialogue)
		dialogue.new_text([
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
])
		

func _on_templo_pressed() -> void:
	blur.visible = true


func _on_abuelo_pressed() -> void:
	Global.fish_quota = int(Global.fish_quota * 1.3)
	get_tree().change_scene_to_file("res://navegacion/navegacion.tscn")


func _on_tienda_pressed() -> void:
	pass # Replace with function body.


func _on_templo_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = templo.name + "\n(bendiciones)"


func _on_abuelo_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = abuelo.name + "\n(acabar el día)"


func _on_tienda_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = tienda.name + "\n(mejorar su barco)"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			blur.visible = false
