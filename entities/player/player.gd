class_name Player
extends CharacterBody2D

@onready  var player_input_synchronizer_component : PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var weapon_root: Node2D = $Visuals/WeaponRoot
@onready var health_component: HealthComponent = $HealthComponent

var bullet_scene : PackedScene = preload("uid://ds1e0jqofdabu")
@onready var fire_rate_timer: Timer = $FireRateTimer

var input_multiplayer_authority: int

func _ready():
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)
	health_component.died.connect(_on_died)
	
func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		velocity = player_input_synchronizer_component.movement_vector * 100
		move_and_slide()
		if player_input_synchronizer_component.is_attack_pressed:
			try_create_bullet()

func update_aim_position():
	var aim_position = weapon_root.global_position \
		+ player_input_synchronizer_component.aim_vector
	weapon_root.look_at(aim_position)

func try_create_bullet():
	if !fire_rate_timer.is_stopped():
		return
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = weapon_root.global_position
	bullet.start(player_input_synchronizer_component.aim_vector)
	get_parent().add_child(bullet, true)
	fire_rate_timer.start()

func _on_died():
	print("player died")
