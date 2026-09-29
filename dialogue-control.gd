extends CanvasLayer

@onready var label = $Dialogo

var type = ""

func new_text(txt):
	label.mode = type
	label.guion = txt
	label.start()
