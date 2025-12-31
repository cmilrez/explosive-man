class_name HurtBox extends Area2D

@export var damage := 1
@export var stun := false
@export var punch := false

func _ready():
	set_collision_mask_value(1, false)
	monitoring = false
	input_pickable = false
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(6, true)
