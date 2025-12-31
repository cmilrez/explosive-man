class_name PassthroughItem extends Item

@export var mask_layer := 0:
	set(value):
		mask_layer = maxi(value, 0)

func apply_effect(target: Bomber):
	target.set_collision_mask_value(mask_layer, false)
	hide()

func remove_effect(target: Bomber):
	target.set_collision_mask_value(mask_layer, true)
	drop()
