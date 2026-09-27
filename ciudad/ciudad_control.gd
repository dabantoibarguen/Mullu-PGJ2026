extends CanvasLayer

@onready var templo = $Templo
@onready var agua = $Agua
@onready var abuelo = $Abuelo
@onready var textBox = $MainText
@onready var blur = $AaronBlur

func _ready() -> void:
	pass


func _on_templo_pressed() -> void:
	blur.visible = true


func _on_abuelo_pressed() -> void:
	pass


func _on_agua_pressed() -> void:
	pass

func _on_templo_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = templo.name



func _on_abuelo_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = abuelo.name


func _on_agua_mouse_entered() -> void:
	textBox.visible = true
	textBox.text = agua.name
