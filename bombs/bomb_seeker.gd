class_name BombSeeker extends Bomb

var target: Node2D

func _physics_process(delta):
	if not is_instance_valid(target):
		super._physics_process(delta)
		return
	if moving:
		return
	var dif := Vector2(target.global_position - global_position).round()
	if dif.length() <= 64.0:
		return
	var next_position := Vector2.ZERO
	if absf(dif.x) > absf(dif.y):
		next_position = Vector2(signf(dif.x), 0) * Global.CELL_SIZE
	else:
		next_position = Vector2(0, signf(dif.y)) * Global.CELL_SIZE
	var move: Tween = $SlideAction.move(self, next_position + global_position, speed)
	if not move:
		return
	moving = true
	move.finished.connect(func(): 
		moving = false
		stopped_moving.emit())

func _on_seek_zone_body_entered(body):
	if body != bomber_owner and not is_instance_valid(target):
		target = body
