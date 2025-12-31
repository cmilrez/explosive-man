class_name CursedSkull extends Item

var new_curse: Curse = null

func apply_effect(target: Bomber):
	new_curse = Curse.new(target)
	target.add_child(new_curse)
	hide()

func remove_effect(target: Bomber):
	if new_curse.property:
		target.set(new_curse.property, new_curse.previous_value)
	new_curse.free()
	#drop()
	show()
