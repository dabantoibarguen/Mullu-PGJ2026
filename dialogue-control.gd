extends CanvasLayer

@onready var label = $Dialogo

func new_text(txt):
	label.guion = txt
	label.start()
