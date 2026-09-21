extends TileMapLayer

var source_id = 4

func _ready() -> void:
	pass
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventMouse:
		if ev.is_pressed() and ev.button_index == 1:
			var coords = self.local_to_map(get_global_mouse_position())
			if get_cell_atlas_coords(coords) != Vector2i(-1, -1):
				%barco.global_position = map_to_local(coords) + Vector2(0, 7)
		else:
			pass
			
func _physics_process(delta: float) -> void:
	pass
			
			
