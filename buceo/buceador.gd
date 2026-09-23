extends CharacterBody2D

@onready var barco = %Barco

var speed = 250

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("", "", "ui_up", "ui_down")
	
	velocity = direction * speed * delta
	
	move_and_collide(velocity)
