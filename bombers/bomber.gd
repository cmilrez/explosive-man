class_name Bomber extends CharacterBody2D

const STATS_LIST: StringName = 'hp,lives,bomb_fuse,bomb_limit,fire_power,speed,invulnerable,kick,hold,punch'

@export var bomb_scene: PackedScene = null:
	set(value):
		if value != null:
			bomb_scene = value
			return
		for item: Item in item_list: # ass
			if item is BombItem and item.scene:
				bomb_scene = item.scene
				return
		bomb_scene = Global.BOMB_NORMAL
var item_list: Array[Item] = []
var cursed_skull: CursedSkull = null
var move_direction := Vector2.ZERO
var facing_direction := Vector2.ZERO
var alive := true
var hp := 1: set = set_hp
var lives := 0: 
	set(value):
		lives = maxi(value, 0)
var bomb_holding: Bomb = null
var bomb_special: Bomb = null
var bomb_fuse := 3.0
var bombs_active := 0
var bomb_limit := 1:
	set(value):
		bomb_limit = clampi(value, 1, Global.max_bombs)
var fire_power := 2:
	set(value):
		fire_power = clampi(value, 1, Global.max_fire)
var speed := 256.0:
	set(value):
		if value == Curse.CURSED_FAST_SPEED or value == Curse.CURSED_SLOW_SPEED:
			speed = value
			return
		speed = clampf(value, Global.min_speed, Global.max_speed)
var speed_multiplier := 1.0
var invulnerable := 0.0:
	set(value):
		invulnerable = maxf(value, 0.0)
		$InvulnerableTimer.start(invulnerable)
		if invulnerable:
			$AnimPlayer.play('invulnerable')
		else:
			$AnimPlayer.stop()
var kick := 0:
	set(value):
		kick = maxi(value, 0)
var hold := 0:
	set(value):
		hold = maxi(value, 0)
var punch := 0:
	set(value):
		punch = maxi(value, 0)

func _ready():
	if not is_instance_valid(bomb_scene):
		bomb_scene = Global.BOMB_NORMAL
	$InvulnerableTimer.timeout.connect(func(): invulnerable = 0.0)

func set_hp(value: int):
	hp = maxi(value, 0)

func hit(damage: int):
	if invulnerable:
		return
	if not damage:
		return
	hp -= damage
	# TODO if hp > 1: become temp invulnerable
	if hp > 0:
		invulnerable = 3.0

func death():
	if alive:
		alive = false
		velocity = Vector2.ZERO
		# TODO drop items
