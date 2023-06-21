extends TileMap
class_name Terrain

enum _LAYERS {
	_WATER = 0,
	_FOAM = 1,
	_TERRAIN = 2,
	_NAVIGATION = 3,
	_DECORATION = 4
}

func _ready() -> void:
	var _used_cells: Array = get_used_cells(_LAYERS._TERRAIN)
	for _cell in _used_cells:
		_set_navigation_cell(_cell)
		_set_water_cell(_cell)
		
		
func _set_navigation_cell(_cell: Vector2i) -> void:
	if get_cell_source_id(_LAYERS._DECORATION, _cell) != -1:
		return
		
	set_cell(
		_LAYERS._NAVIGATION,
		_cell,
		3,
		Vector2i.ZERO
	)
	
	
func _set_water_cell(_cell: Vector2i) -> void:
	set_cell(
		_LAYERS._WATER,
		_cell,
		-1
	)
