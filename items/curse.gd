class_name Curse extends Node

const CURSED_SLOW_SPEED = 128.0
const CURSED_FAST_SPEED = 1024.0
enum Curses {SLOW_SPEED, FAST_SPEED, WEAK_FIRE, FAST_FUSE, SLOW_FUSE_A,
			SLOW_FUSE_B, DIARRHEA, INVERT_CONTROL, ALWAYS_MOVE, NO_BOMBS}
var curse_type: Curses = Curses.FAST_SPEED
var target: Bomber = null
var last_direction := Vector2.LEFT
var property: StringName = ''
var previous_value: Variant = null

func _init(new_target: Bomber):
	self.target = new_target
	self.curse_type = Curses.values().pick_random()
	self.name = Curses.find_key(curse_type)
	match curse_type:
		Curses.SLOW_SPEED:
			property = 'speed'
		Curses.FAST_SPEED:
			property = 'speed'
		Curses.WEAK_FIRE:
			property = 'fire_power'
		Curses.FAST_FUSE:
			property = 'bomb_fuse'
		Curses.SLOW_FUSE_A:
			property = 'bomb_fuse'
		Curses.SLOW_FUSE_B:
			property = 'bomb_fuse'
	if property:
		previous_value = target.get(property)

func apply_curse():
	match curse_type:
		Curses.SLOW_SPEED:
			target.speed = CURSED_SLOW_SPEED
		Curses.FAST_SPEED:
			target.speed = CURSED_FAST_SPEED
		Curses.WEAK_FIRE:
			target.fire_power = 1
		Curses.FAST_FUSE:
			target.bomb_fuse = 1.5
		Curses.SLOW_FUSE_A:
			target.bomb_fuse = 3.5
		Curses.SLOW_FUSE_B:
			target.bomb_fuse = 4.0
		Curses.DIARRHEA:
			target.make_bomb()
		Curses.INVERT_CONTROL:
			target.velocity *= -1
			if target.move_direction:
				target.facing_direction = Global.snap_card(-target.move_direction)
		Curses.ALWAYS_MOVE:
			var dir := Vector2.ZERO
			if Input.is_action_pressed('move_up'):
				dir.y = -1
			elif Input.is_action_pressed('move_down'):
				dir.y = 1
			else:
				dir.y = 0
			if Input.is_action_pressed('move_left'):
				dir.x = -1
			elif Input.is_action_pressed('move_right'):
				dir.x = 1
			else:
				dir.x = 0
			if dir:
				last_direction = dir.normalized()
			target.velocity = last_direction * target.speed
		Curses.NO_BOMBS:
			target.bombs_active = 999
