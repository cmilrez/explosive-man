extends Node

const ERR = preload('res://misc/error.png')
const BOMB_NORMAL = preload('res://bombs/bomb_normal.tscn')
const BOMB_SPIKE = preload('res://bombs/bomb_spike.tscn')
const BOMB_SEEKER = preload('res://bombs/bomb_seeker.tscn')
const SNAP_VECTOR := Vector2(64, 64)
const CELL_SIZE := 64

var max_bombs := 8
var max_fire := 8
var min_speed := 128.0
var max_speed := 512.0

var grid_map: NavGrid = null

## Snaps Vector2 to cardinal directions, x=y favors Y axis.
func snap_vector(vector: Vector2) -> Vector2:
	if abs(vector.x) > abs(vector.y):
		vector = Vector2(signf(vector.x), 0.0)
	else:
		vector = Vector2(0.0, signf(vector.y))
	return vector
