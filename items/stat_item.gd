@tool
class_name StatItem extends Item

@export_enum(' ') var stat: String
@export var value_change = 1

func _validate_property(property):
	if property.name == 'stat':
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = Bomber.STATS_LIST

func apply_effect(target: Bomber):
	var new_value = target.get(stat) + value_change
	target.set(stat, new_value)
	hide()

func remove_effect(target: Bomber):
	var new_value = target.get(stat) - value_change
	target.set(stat, new_value)
	drop()
