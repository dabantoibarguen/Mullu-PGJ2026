extends Control

var max_oxygen = 120
var oxygen = max_oxygen
@onready var oxygen_bar = %OxygenBar
@onready var escapeButton = $EscapeBtn

var buceo # The buceo scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oxygen_bar.get_theme_stylebox("fill").bg_color = Color(0.639, 0.639, 0.639, 0.745)
	oxygen_bar.value = oxygen
	oxygen = max_oxygen
	buceo = get_parent().get_parent()

func _on_oxygen_timer_timeout() -> void:
	buceo.update_escape()
	escapeButton.disabled = !buceo.can_escape
	oxygen -= 1.1
	oxygen_bar.value = oxygen
	if oxygen <= max_oxygen/3:
		if !%Hearbeat.playing:
			%Hearbeat.play()
		oxygen_bar.get_theme_stylebox("fill").bg_color = Color(0.716, 0.0, 0.0, 1.0)
	if oxygen <= 0:
		buceo.pass_out()
		%OxygenTimer.stop()


func _on_escape_btn_pressed() -> void:
	buceo.escape_safely()
