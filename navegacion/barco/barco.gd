extends CharacterBody2D

@onready var target = global_position
@onready var oceanMap = %OceanMap
@onready var label = $Label
@onready var vision = %Vision

var speed = 75
var cur_coords
var vision_range = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	cur_coords = oceanMap.local_to_map(global_position)
	target = oceanMap.map_to_local(cur_coords)


func _physics_process(delta):
	velocity = global_position.direction_to(target).normalized() * speed
	if global_position.distance_to(target)<1:
		velocity = Vector2(0,0)
	else:
		move_and_slide()
	label.text = str(cur_coords)
		
