extends CharacterBody2D

@onready var area = %FishingArea
@onready var cuerda = %Line

var oldpos = global_position

var speed = 400

func _ready() -> void:
	cuerda.add_point(global_position)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = direction * speed * delta

	if Geometry2D.is_point_in_polygon(area.to_local(global_position), area.polygon):
		move_and_collide(velocity)
		oldpos = global_position - velocity*1
	else:
		global_position = oldpos
	cuerda.remove_point(1)
	cuerda.add_point(global_position)

	
