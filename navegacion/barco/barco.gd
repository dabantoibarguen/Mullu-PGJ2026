extends CharacterBody2D

@onready var target = global_position
@onready var oceanMap = %OceanMap
@onready var label = $Label
@onready var energyText = %TotalEnergy

var speed = 75
var cur_coords
var vision_range = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	cur_coords = oceanMap.local_to_map(global_position)
	target = oceanMap.map_to_local(cur_coords)
	energyText.text = "30/30"

func _physics_process(_delta):
	velocity = global_position.direction_to(target).normalized() * speed
	if global_position.distance_to(target)<1:
		velocity = Vector2(0,0)
	else:
		move_and_slide()
		
