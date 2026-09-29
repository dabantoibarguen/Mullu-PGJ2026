extends CharacterBody2D

@onready var area = %FishingArea
@onready var cuerda = %Line

var oldpos = global_position

var speed = 350

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Global.tutorial_index == 3:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Rotate the sprite smoothly every frame
	rotate(deg_to_rad(-67 * delta))
	
	velocity = direction * speed * delta

	if not Geometry2D.is_point_in_polygon(area.to_local(global_position), area.polygon):
		# This could realistically be skipped, but it's a safety net.
		global_position = oldpos
	elif Geometry2D.is_point_in_polygon(area.to_local(global_position + velocity), area.polygon):
		move_and_collide(velocity)
	oldpos = position

	
