extends TileMapLayer

var source_id = 4

func _ready() -> void:
	pass
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventMouse and ev.is_pressed():
		if ev.button_index == 1:
			var coords = self.local_to_map(get_global_mouse_position())
			%barco.global_position = map_to_local(coords) + Vector2(0, 8)
			
			
