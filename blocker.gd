extends Control

func _ready() -> void:
		focus_mode = Control.FOCUS_ALL
		grab_focus()

func _gui_input(event: InputEvent) -> void:
	accept_event()
