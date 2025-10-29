class_name Player
extends CharacterBody2D

@onready  var player_input_synchronizer_component : PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var weapon_root: Node2D = $Visuals/WeaponRoot
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrel_position: Marker2D = %BarrelPosition

var bullet_scene : PackedScene = preload("uid://ds1e0jqofdabu")
var muzzle_flash_scene : PackedScene = preload("uid://cyhc4fkhlgpr")
var flashbang : PackedScene = preload("uid://cpffxup4ywymm")

@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var flashbang_cooldown: Timer = $FlashbangCooldown

var input_multiplayer_authority: int
var died: bool

func _ready():
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)
	health_component.died.connect(_on_died)
	
func _process(_delta: float) -> void:
	update_aim_position()
	if is_multiplayer_authority():
		velocity = player_input_synchronizer_component.movement_vector * 100
		move_and_slide()
		if player_input_synchronizer_component.is_attack_pressed:
			try_fire()
		if player_input_synchronizer_component.is_flash_pressed:
			try_flash_bang()

func update_aim_position():
	var aim_vector = player_input_synchronizer_component.aim_vector
	var aim_position = weapon_root.global_position \
		+ player_input_synchronizer_component.aim_vector
	visuals.scale = Vector2.ONE if aim_vector.x >= 0 else Vector2(-1,1)
	weapon_root.look_at(aim_position)

func try_flash_bang():
	if !flashbang_cooldown.is_stopped() or died:
		return
	print("flash")
	var flashbang = flashbang.instantiate() as Flashbang
	flashbang.global_position = barrel_position.global_position
	flashbang.start(player_input_synchronizer_component.aim_vector)
	get_parent().add_child(flashbang, true)
	flashbang_cooldown.start()

func try_fire():
	if !fire_rate_timer.is_stopped() or died:
		return
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = barrel_position.global_position
	bullet.start(player_input_synchronizer_component.aim_vector)
	get_parent().add_child(bullet, true)
	fire_rate_timer.start()
	play_fire_effects.rpc()


@rpc("authority", "call_local", "unreliable")
func play_fire_effects():
	if animation_player.is_playing():
		animation_player.stop
	animation_player.play("fire")
	
	var muzzle_flash : Node2D = muzzle_flash_scene.instantiate()
	muzzle_flash.global_position = barrel_position.global_position
	muzzle_flash.global_rotation = barrel_position.global_rotation
	get_parent().add_child(muzzle_flash)

func _on_died():
	died = true
	
	print("player died")
	var tween := create_tween()
	tween.tween_property(visuals, "scale", Vector2.ZERO, .4)\
	.from(Vector2.ONE)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	#tween.finished.connect(func ():
	#	queue_free()
	#	)
