extends CharacterBody2D

@onready var soga = %Soga
var playing = false

var speed = 250

func _ready() -> void:
	soga.add_point(Vector2(0, -20))
	soga.add_point(global_position)
	
func _physics_process(delta: float) -> void:
	if playing:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = direction * speed * delta
	
	soga.remove_point(1)
	move_and_collide(velocity)
	soga.add_point(global_position+ Vector2(0, 100))
	
