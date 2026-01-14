class_name Move extends RayCast2D

func slide(node: Node2D, direction: Vector2, velocity: float) -> Tween:
	target_position = direction * Global.CELL_SIZE
	force_raycast_update()
	if is_colliding():
		return null
	var tween = node.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var duration = float(Global.CELL_SIZE) / velocity
	var to_position = target_position + node.global_position
	tween.tween_property(node, 'global_position', to_position, duration)
	return tween

## length is amount of cells (Global.CELL_SIZE)
func jump(node: Node2D, direction: Vector2, length: float) -> Tween:
	var tween = node.create_tween().set_trans(Tween.TRANS_SINE).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var duration = 0.3
	# out of bounds check
	var view = get_viewport_rect().size
	if node.global_position.x < 0.0:
		node.global_position.x = view.x + Global.CELL_SIZE / 2.0
	elif node.global_position.x > view.x:
		node.global_position.x = -Global.CELL_SIZE / 2.0
	if node.global_position.y < 0.0:
		node.global_position.y = view.y + Global.CELL_SIZE / 2.0
	elif node.global_position.y > view.y:
		node.global_position.y = -Global.CELL_SIZE / 2.0
	
	if direction.x:
		var to_position = Vector2(direction.x * length * Global.CELL_SIZE, -96.0) + node.global_position		
		tween.set_parallel()
		tween.tween_property(node, 'global_position:x', to_position.x, duration)
		tween.tween_property(node, 'global_position:y', to_position.y, duration/2.0).set_ease(Tween.EASE_IN)
		tween.tween_property(node, 'global_position:y', node.global_position.y, duration/2.0).set_ease(Tween.EASE_OUT).set_delay(duration/2.0)
	else:
		var height = direction.y * length * Global.CELL_SIZE + node.global_position.y
		tween.tween_property(node, 'global_position:y', height+(16.0*direction.y), duration*2.0/3.0).set_ease(Tween.EASE_OUT)
		tween.tween_property(node, 'global_position:y', height, duration/3.0).set_ease(Tween.EASE_OUT)
	return tween
