extends Area2D

@onready var anim = $IndicadoresPesca
@onready var timer = $Borrar
@onready var catch = $Atrapar
var player
var entered = false

func _ready() -> void:
	catch.wait_time = 0.8
	anim.play("Spin")
	timer.wait_time = 2.5
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	body.speed = 50
	timer.paused = true
	catch.start()
	

func _on_body_exited(body: Node2D) -> void:
	body.speed = 400
	timer.paused = false
	catch.stop()

func _on_borrar_timeout() -> void:
	queue_free()
	

func _on_atrapar_timeout() -> void:
	get_parent().go_fish(self)
	timer.stop()
	catch.stop()

func _physics_process(_delta: float) -> void:
	var dist = global_position.distance_to(player.global_position)
	if(dist<15):
		if !entered:
			entered = true
			player.speed = 50
			timer.paused = true
			catch.start()
	else:
		if entered:
			entered = false
			player.speed = 400
			timer.paused = false
			catch.stop()
