class_name BreakableBlock extends AnimatableBody2D

@onready var anim_sprite = $AnimatedSprite2D

func destroy():
	anim_sprite.play('default')
	await anim_sprite.animation_finished
	queue_free()

func _on_hitbox_area_entered(area: HurtBox):
	if area.damage:
		destroy()
	# Move when hit by rabbit kick
	#$SlideAction.move()
