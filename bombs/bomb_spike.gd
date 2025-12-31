class_name BombSpike extends Bomb

func detonate():
	fuse_timer.stop()
	var new_explosion = make_explosion()
	new_explosion.set_piercing(true)
	get_tree().current_scene.add_child(new_explosion)
	queue_free()
