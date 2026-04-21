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

## Returns normalized cardinal vector,  x=y favors Y axis.
func snap_card(vector: Vector2) -> Vector2:
	if absf(vector.x) > absf(vector.y):
		vector = Vector2(signf(vector.x), 0.0)
	else:
		vector = Vector2(0.0, signf(vector.y))
	return vector

## Snaps vector to a grid of Global.CELL_SIZE.
func snap_grid(vector: Vector2) -> Vector2:
	var half_cell = Vector2.ONE * CELL_SIZE / 2.0
	vector -= half_cell
	return vector.snappedf(CELL_SIZE) + half_cell
