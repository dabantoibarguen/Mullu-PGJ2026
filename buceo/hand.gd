extends CharacterBody2D


@onready var trail = %PlayerTrail
@onready var target = %Shape
@onready var integrity_bar = %Integrity
@onready var indicator = %Indicator

var helper
var indicator_size

var move_speed = 150.0
var rotation_speed = 3.0

const MAX_STRAY = 10.0
const CORNER_RADIUS = 7.0

var next_vertex_index = 1
var seg_start
var seg_end

var damage_rate = 30.0
var integrity = 0
var target_points

var oldPos = position



func _ready():
	helper = Line2D.new()
	helper.default_color = Color("ffae00")
	helper.width = 1
	indicator_size = indicator.scale
	
func start_game():
	indicator.scale = indicator_size
	integrity_bar.value = integrity
	integrity_bar.get_theme_stylebox("fill").bg_color = Color("3b6125")
	helper.clear_points()
	trail.clear_points()
	rotation = 0
	next_vertex_index = 1
	target_points = target.points
	global_position = target.to_global(target_points[0])
	trail.add_point(trail.to_local(global_position))
	helper.add_point(trail.to_local(global_position))
	update_segment()
	indicator.visible = true
	get_parent().add_child(helper)
	
# Old system, distance based (just like navigation energy)
#func calculate_line_length(target: Line2D) -> float:
	#var total_length: float = 0.0
	#var points = target.points
	#if points.size() < 2:
		#return 0.0
		#
	#for i in range(points.size() - 1):
		#var global_p1 = target.to_global(points[i])
		#var global_p2 = target.to_global(points[i + 1])
		#total_length += global_p1.distance_to(global_p2)
		#
	#return total_length

func update_segment():
	target_points = target.points
	var total_points = target_points.size()
	if total_points >= 2:
		seg_start = target.to_global(target_points[(next_vertex_index - 1) % total_points])
		seg_end = target.to_global(target_points[(next_vertex_index) % total_points])
	indicator.global_position = seg_end
	helper.add_point(trail.to_local(seg_end))
		
func end_game(victory):
	await get_tree().create_timer(1.5).timeout 
	get_parent().remove_child(helper)
	get_tree().current_scene.end_snip(victory)

func _physics_process(delta: float) -> void:
	if integrity <= 0:
		return
		
	var rotation_dir = Input.get_axis("ui_left", "ui_right")
	global_rotation += rotation_dir * rotation_speed * delta
	
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * move_speed * delta
	elif Input.is_action_pressed("ui_down"):
		velocity = Vector2.DOWN.rotated(rotation) * move_speed * delta
	else:
		velocity = Vector2.ZERO
	

	move_and_collide(velocity)
	

	var closest_point = Geometry2D.get_closest_point_to_segment(global_position, seg_start, seg_end)
	var current_drift = global_position.distance_to(closest_point)
	trail.default_color = Color("008300ff")
	if current_drift > MAX_STRAY:
		trail.default_color = Color("9e000cff")
		integrity -= damage_rate * delta * (current_drift/MAX_STRAY)
		integrity_bar.value = integrity
		if integrity <= 0.0:
			end_game(false)
			return
		elif integrity <= 33:
			integrity_bar.get_theme_stylebox("fill").bg_color = Color(0.716, 0.0, 0.0, 1.0)
		elif integrity <= 66:
			integrity_bar.get_theme_stylebox("fill").bg_color = Color(0.627, 0.549, 0.0, 1.0)

	if global_position.distance_to(seg_end) <= CORNER_RADIUS:
		if next_vertex_index < target_points.size():
			next_vertex_index += 1
			update_segment()
		else:
			indicator.position = Vector2.ZERO
			indicator.scale = Vector2(0.2, 0.2)
			integrity = 0
			end_game(true)
	
	if global_position != oldPos:
		trail.add_point(trail.to_local(global_position))
		oldPos = global_position
			
