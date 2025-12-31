extends Node2D

func move(node: Node2D, to_position: Vector2, velocity: float) -> Tween:
	$Ray.target_position = node.global_position.direction_to(to_position) * Global.CELL_SIZE
	$Ray.force_raycast_update()
	if $Ray.is_colliding():
		return null
	var tween := self.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var duration := float(Global.CELL_SIZE) / velocity
	tween.tween_property(node, 'global_position', to_position, duration)
	return tween
