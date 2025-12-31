class_name Bomb extends AnimatableBody2D

signal stopped_moving

const explosion_scene = preload('res://explosion/explosion.tscn')

@export var one_only := false
@export var speed := 256.0
@export var fuse := 3.0:
	set(value):
		fuse = maxf(value, 0.1)
@export var fire_power := 1:
	set(value):
		fire_power = maxi(value, 0)
var moving := false
var held := false:
	set(value):
		held = value
		fuse_timer.paused = held
		set_collision_layer_value(3, not held)
var move_direction := Vector2.ZERO
var fuse_timer: Timer = null
var ray: RayCast2D = null
var bomber_owner: Player = null

func _ready():
	fuse_timer = $FuseTimer
	fuse_timer.one_shot = true
	fuse_timer.timeout.connect(_on_fuse_timer_timeout)
	fuse_timer.start(fuse)
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(_delta):
	if move_direction and not moving:
		var move: Tween = $SlideAction.move(self, Global.CELL_SIZE * move_direction + global_position, 2.0 * speed)
		if not move:
			#moving = false
			move_direction = Vector2.ZERO
			return
		moving = true
		move.finished.connect(func(): 
			moving = false
			stopped_moving.emit())

func jump(direction: Vector2):
	pass

func make_explosion():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.fire_power = self.fire_power
	new_explosion.global_position = self.global_position
	return new_explosion

func detonate():
	#fuse_timer.stop()
	if moving:
		await stopped_moving
	var new_explosion = make_explosion()
	get_tree().current_scene.add_child(new_explosion)
	queue_free()

func _on_fuse_timer_timeout():
	detonate()

func _on_hitbox_area_entered(area: HurtBox):
	if area.damage:
		fuse_timer.start(0.05)
	if area.punch:
		#jump()
		pass
