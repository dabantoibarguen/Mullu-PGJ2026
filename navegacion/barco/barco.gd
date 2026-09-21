extends CharacterBody2D

@onready var target = global_position
@onready var oceanMap = %OceanMap
var speed = 75
var cur_coords

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_coords = oceanMap.local_to_map(global_position)


func _physics_process(delta):
	velocity = global_position.direction_to(target).normalized() * speed
	if global_position.distance_to(target)<1:
		velocity = Vector2(0,0)
	else:
		# we've reached current destination, get the next one (if any left)
		move_and_slide()
		#if tile_path.size():
			#tile_position = tile_path.pop_front()
			#target = world_path.pop_front()
