class_name Bomb extends AnimatableBody2D

signal stopped_moving

const explosion_scene = preload('uid://vqavdudydoe5')

@export var one_only := false
@export var speed := 256.0
@export var fuse := 3.0:
	set(value):
		fuse = maxf(value, 0.1)
@export var fire_power := 1:
	set(value):
		fire_power = maxi(value, 0)
var moving := false:
	set(value):
		if moving and not value: stopped_moving.emit()
		moving = value
var fuse_timer: Timer = null
var bomber_owner: Player = null

func _ready():
	fuse_timer = $FuseTimer
	fuse_timer.one_shot = true
	fuse_timer.timeout.connect(_on_fuse_timer_timeout)
	fuse_timer.start(fuse)
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)

func begin_slide(direction: Vector2):
	var tween: Tween = $Move.slide(self, direction, 2.0 * speed)
	if not tween:
		moving = false
		return
	moving = true
	tween.finished.connect(begin_slide.bind(direction))

func begin_jump(direction: Vector2, length := 3.0):
	var tween: Tween = $Move.jump(self, direction, length)
	moving = true
	z_index = 2
	freeze(moving)
	tween.finished.connect(func():
		var query_param = PhysicsPointQueryParameters2D.new()
		query_param.collision_mask = collision_mask
		query_param.position = global_position
		var intersection = get_world_2d().direct_space_state.intersect_point(query_param, 1)
		if intersection:
			if intersection[0].collider is Explosion:
				moving = false
				z_index = 0
				fuse_timer.paused = moving
				fuse_timer.start(0.1)
				return
			begin_jump(direction, 1.0)
			return
		moving = false
		z_index = 0
		freeze(moving))

func make_explosion():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.fire_power = self.fire_power
	new_explosion.global_position = self.global_position
	return new_explosion

func detonate():
	if moving:
		await stopped_moving
	var new_explosion = make_explosion()
	get_tree().current_scene.add_child(new_explosion)
	queue_free()

func freeze(value: bool):
	fuse_timer.paused = value
	$BodyCollision.set_deferred('disabled', value)
	$Hitbox/HitCollision.set_deferred('disabled', value)

func _on_fuse_timer_timeout():
	detonate()

func _on_hitbox_area_entered(area: HurtBox):
	if area.damage:
		fuse_timer.start(0.1)
	if area.punch:
		var collision_shape = area.shape_owner_get_owner(0)
		begin_jump(Global.snap_card(collision_shape.position))
