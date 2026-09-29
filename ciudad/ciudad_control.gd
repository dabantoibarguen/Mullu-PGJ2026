extends CanvasLayer

@onready var templo = $Templo
@onready var tienda = $Tienda
@onready var abuelo = $Abuelo
@onready var textBox = $MainText
@onready var blur = $AaronBlur

func _ready() -> void:
	pass


func _on_templo_pressed() -> void:
	blur.visible = true


func _on_abuelo_pressed() -> void:
	pass


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
