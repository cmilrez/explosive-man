class_name Player extends Bomber

@onready var bomb_bag := $BombBag
@onready var anim_tree := $AnimationTree
@onready var body_shape := $BodyShape
@onready var hitbox_shape := $Hitbox/HitboxShape
@onready var hitbox := $Hitbox
@onready var bomb_spawn := $BombSpawn

@export var tile_layer: TileMapLayer = null
@export var read_input := true

var anim_state_machine: AnimationNodeStateMachinePlayback

func _ready():
	super._ready()
	anim_tree.active = true
	anim_state_machine = anim_tree.get('parameters/playback')

func _process(_delta):
	if not alive:
		return
	if hp <= 0:
		if lives > 0: # actually should reload scene
			lives -= 1
			hp = 1
		else:
			anim_state_machine.travel('death')
			death()
			return

func _physics_process(_delta):
	if read_input:
		if Input.is_action_pressed('move_up'):
			move_direction.y = -1
		elif Input.is_action_pressed('move_down'):
			move_direction.y = 1
		else:
			move_direction.y = 0
		if Input.is_action_pressed('move_left'):
			move_direction.x = -1
		elif Input.is_action_pressed('move_right'):
			move_direction.x = 1
		else:
			move_direction.x = 0
		if Input.is_action_pressed('make_bomb'):# and not bomb_holding:
			make_bomb()
	else:
		move_direction = Vector2.ZERO
	if move_direction:
		velocity = move_direction.normalized() * speed * speed_multiplier
		facing_direction = Global.snap_card(move_direction)
	else:
		velocity = Vector2.ZERO
	bombs_active = bomb_bag.get_child_count()
	if cursed_skull:
		cursed_skull.new_curse.apply_curse()
	set_animation_param()
	
	if not move_and_slide():
		return
	if not velocity:
		return
	if not kick:
		return
	var last_collider = get_last_slide_collision().get_collider()
	if last_collider is Bomb:
		var dir_to_bomb: Vector2 = bomb_spawn.global_position.direction_to(last_collider.global_position)
		var dot_prod := dir_to_bomb.dot(facing_direction)
		if dot_prod < 0.9: # ~50°
			return
		last_collider.begin_slide(facing_direction)

func _unhandled_key_input(event):
	if not alive:
		return
	#if event.is_action_released('make_bomb') and bomb_holding:
		#anim_tree['parameters/throw/blend_position'] = facing_direction
		#anim_state_machine.travel('throw')
		#bomb_holding.jump(facing_direction)
		#bomb_holding.held = false
		#bomb_holding = null
	if event.is_action_pressed('punch_action') and punch:
		anim_tree['parameters/punch/blend_position'] = facing_direction
		anim_state_machine.travel('punch')
	if event.is_action_pressed('bomb_action'):
		if not bomb_bag.get_child_count():
			return
		var first_bomb = bomb_bag.get_child(0)
		if first_bomb is BombRemote:
			first_bomb.detonate()

func set_animation_param():
	if bomb_holding:
		anim_tree['parameters/hold_idle/blend_position'] = facing_direction
		anim_tree['parameters/hold_walk/blend_position'] = facing_direction
	else:
		anim_tree['parameters/idle/blend_position'] = facing_direction
		anim_tree['parameters/walk/blend_position'] = facing_direction

func make_bomb():
	if hitbox.has_overlapping_bodies():
		return
	if bombs_active < bomb_limit:
		var new_bomb: Node2D = null
		if is_instance_valid(bomb_special):
			new_bomb = Global.BOMB_NORMAL.instantiate()
		else:
			new_bomb = bomb_scene.instantiate()
		if new_bomb is Bomb:
			if new_bomb.one_only:
				bomb_special = new_bomb
			new_bomb.bomber_owner = self
			new_bomb.fuse = bomb_fuse
			new_bomb.fire_power = fire_power
			add_collision_exception_with(new_bomb)
		new_bomb.global_position = Global.snap_grid(bomb_spawn.global_position)
		bomb_bag.add_child(new_bomb)

func set_hp(value: int):
	if hp == 0 and value > 0:
		revive()
	hp = maxi(value, 0)

func revive():
	if not alive:
		alive = true
		read_input = true
		hitbox_shape.set_deferred('disabled', false)
		body_shape.set_deferred('disabled', false)
		anim_state_machine.travel('Start')

func _on_hitbox_body_exited(body):
	if body is Bomb:
		remove_collision_exception_with(body)

func _on_hitbox_area_entered(area: Area2D):
	if area is HurtBox:
		if area.stun:
			pass # TODO stun
		hit(area.damage)
		return
	if area is Item:
		if area is CursedSkull:
			cursed_skull = area
			$AnimPlayer.play('cursed')
		elif cursed_skull:
			item_list.erase(cursed_skull)
			cursed_skull.remove_effect(self)
			cursed_skull = null
			$AnimPlayer.stop()
		item_list.append(area)
		area.apply_effect(self)
		return
