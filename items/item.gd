class_name Item extends Area2D

@onready var border: AnimatedSprite2D = $Border
@onready var icon: Sprite2D = $Border/Icon
@onready var collision: CollisionShape2D = $AreaCollision

func _ready():
	if Engine.is_editor_hint():
		return
	self.area_entered.connect(_on_area_entered)
	self.visibility_changed.connect(func(): toggle_on_off(visible))
	border.frame += randi_range(-5, 5)

# Override
func apply_effect(_target: Bomber):
	pass

# Override
func remove_effect(_target: Bomber):
	pass

func drop():
	# TODO drop item in random place
	pass

func toggle_on_off(value: bool):
	set_deferred('monitoring', value)
	collision.set_deferred('disabled', not value)

func _on_area_entered(area: Area2D):
	if area is HurtBox:
		if not area.damage:
			return
		toggle_on_off(false)
		icon.hide()
		border.offset = Vector2(0, -8)
		border.play('destroyed')
		await border.animation_finished
		queue_free()
		return
	if area.get_collision_layer_value(3) or area.get_collision_layer_value(4):
		queue_free()
