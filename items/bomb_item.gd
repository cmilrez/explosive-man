class_name BombItem extends Item

@export_file('*.tscn') var scene_path: String
var scene: PackedScene

func _ready():
	scene = load(scene_path)
	super._ready()

func apply_effect(target: Bomber):
	if scene:
		target.bomb_scene = scene
		hide()

func remove_effect(target: Bomber):
	target.bomb_scene = null
	drop()
