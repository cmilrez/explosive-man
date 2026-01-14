class_name BombSeeker extends Bomb

var target: Node2D:
	set(value):
		if not value == bomber_owner:
			$SeekZone.set_deferred('monitoring', false)
			target = value

func _physics_process(_delta):
	if is_instance_valid(target) and not moving:
		pursue_target()

func begin_slide(direction: Vector2):
	if is_instance_valid(target):
		moving = false # WARNING ?? position may desync with the grid ??
		return
	super.begin_slide(direction)

func pursue_target():
	var dif := Vector2(target.global_position - global_position)#.round() ?
	if dif.length() <= 64.0:
		return
	var direction := Vector2.ZERO
	if absf(dif.x) > absf(dif.y):
		direction = Vector2(signf(dif.x), 0)
	else:
		direction = Vector2(0, signf(dif.y))
	var tween: Tween = $Move.slide(self, direction, speed)
	if not tween:
		moving = false
		return
	moving = true
	tween.finished.connect(func(): moving = false)

func _on_seek_zone_body_entered(body):
	target = body
