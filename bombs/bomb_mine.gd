class_name BombMine extends Bomb

func _ready():
	super._ready()
	fuse_timer.stop()
	#set_collision_layer_value(3, false)
	$Hitbox.set_collision_mask_value(6, false)
	$Hitbox.set_collision_mask_value(1, true)

func _on_hitbox_area_entered(_area):
	fuse_timer.start(0.6)
	$AnimationPlayer.play_backwards('bomb_mine_anim')
