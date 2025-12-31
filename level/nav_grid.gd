class_name NavGrid extends Node

@export var tile_layer: TileMapLayer
var astar_grid := AStarGrid2D.new()

func _ready():
	Global.grid_map = self
	setup_astar_grid()
	tile_layer.child_exiting_tree.connect(_on_tile_map_layer_child_exiting_tree)

func setup_astar_grid():
	astar_grid.region = tile_layer.get_used_rect()
	astar_grid.cell_size = Vector2.ONE * Global.CELL_SIZE
	astar_grid.offset = Global.SNAP_VECTOR * 0.5
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	var block_list = tile_layer.get_children()
	for block in block_list:
		astar_grid.set_point_solid(tile_layer.local_to_map(block.position))
		#var mark := Sprite2D.new()
		#mark.texture = Global.ERR
		#mark.scale *= 4
		#mark.position = astar_grid.get_point_position(tile_layer.local_to_map(block.position))
		#add_child(mark)

func get_next_path(start_position: Vector2, target_position: Vector2) -> PackedVector2Array:
	var start_point: Vector2i = tile_layer.local_to_map(tile_layer.to_local(start_position))
	var target_point: Vector2i = tile_layer.local_to_map(tile_layer.to_local(target_position))
	if not astar_grid.is_in_boundsv(start_point):
		push_warning('NavGrid: START(' + str(start_point) + ') position out of bounds')
		return PackedVector2Array()
	if not astar_grid.is_in_boundsv(target_point):
		push_warning('NavGrid: TARGET(' + str(target_point) + ') position out of bounds')
		return PackedVector2Array()
	var grid_path := astar_grid.get_point_path(start_point, target_point)
	return grid_path

func _on_tile_map_layer_child_exiting_tree(node):
	if node is BreakableBlock:
		astar_grid.set_point_solid(tile_layer.local_to_map(node.position), false)
