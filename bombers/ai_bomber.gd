extends Bomber

@onready var anim_tree := $AnimationTree

@export var pos_targets: Array[Marker2D] = []
var i := 0
var direction := Vector2.ZERO
var moving := false

func _ready():
	anim_tree.active = true

func _physics_process(_delta):
	if pos_targets:
		if not moving:
			i += 1
			if i >= pos_targets.size():
				i = 0
			var next_position: Vector2 = pos_targets[i].global_position
			next_position.y += 32.0
			direction = global_position.direction_to(next_position)
			var duration := global_position.distance_to(next_position) / speed
			moving = true
			get_tree().create_timer(duration, false).timeout.connect(func(): moving = false)
	velocity = direction * speed
	move_and_slide()
	anim_tree['parameters/conditions/idle'] = not moving
	anim_tree['parameters/conditions/walk'] = moving
	anim_tree['parameters/walk/blend_position'] = direction
