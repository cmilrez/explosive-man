class_name Explosion extends Node2D

@onready var segments := $Segments
@onready var ray := $Ray

const DIRECTIONS = {'Down': Vector2.DOWN, 'Left': Vector2.LEFT, 'Up': Vector2.UP, 'Right': Vector2.RIGHT}
const EXPLOSION_H := preload('res://explosion/explosion_sprites/middle_horizontal.tscn')
const EXPLOSION_V := preload('res://explosion/explosion_sprites/middle_vertical.tscn')
const EXPLOSION_MIDDLE := { 'Down': EXPLOSION_V,
							'Left': EXPLOSION_H,
							'Up': EXPLOSION_V,
							'Right': EXPLOSION_H }
const EXPLOSION_TIP := {'Down': preload('res://explosion/explosion_sprites/tip_down.tscn'),
						'Left': preload('res://explosion/explosion_sprites/tip_left.tscn'),
						'Up': preload('res://explosion/explosion_sprites/tip_up.tscn'),
						'Right': preload('res://explosion/explosion_sprites/tip_right.tscn')}
var fire_power := 2

func _ready():
	for direction in DIRECTIONS:
		ray.target_position = fire_power * DIRECTIONS[direction] * Global.SNAP_VECTOR
		ray.force_raycast_update()
		if ray.is_colliding():
			var collision_point: Vector2 = ray.get_collision_point()
			var steps = roundi(Vector2(to_local(collision_point) * DIRECTIONS[direction]).length()/Global.CELL_SIZE)
			if steps > 0:
				for step in steps:
					var new_segment: Node = EXPLOSION_MIDDLE[direction].instantiate()
					if step == steps - 1:
						new_segment.get_child(0).free()
					new_segment.position = DIRECTIONS[direction] * (step + 1) * Global.SNAP_VECTOR
					segments.add_child(new_segment)
		else:
			for step in fire_power:
				var new_segment
				if step == fire_power - 1:
					new_segment = EXPLOSION_TIP[direction].instantiate()
				else:
					new_segment = EXPLOSION_MIDDLE[direction].instantiate()
				new_segment.position = DIRECTIONS[direction] * (step + 1) * Global.SNAP_VECTOR
				segments.add_child(new_segment)

func set_piercing(value: bool):
	$Ray.set_collision_mask_value(4, not value) # breakable walls
	$Ray.set_collision_mask_value(5, not value) # items

func _on_timer_timeout():
	queue_free()
