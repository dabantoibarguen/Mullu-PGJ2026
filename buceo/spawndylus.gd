extends Area2D

var player
var catchable = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dist = global_position.distance_to(player.global_position)
	if(dist<90):
		catchable = true
	else:
		catchable = false


func _on_foto_pressed() -> void:
	if catchable:
		get_parent().start_snip(self)
