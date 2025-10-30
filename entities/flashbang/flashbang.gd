class_name Flashbang
extends Node2D

var SPEED: int = 600
@onready var time_until_flash: Timer = $TimeUntilFlash
@onready var flash_time: Timer = $FlashTime
var direction: Vector2
const SOLID_WHITE = preload("res://entities/flashbang/Solid_white.png")
#var image: Image = SOLID_WHITE
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash: Sprite2D = $Flash

func _ready() -> void:
	sprite_2d.self_modulate.a = 0
	time_until_flash.timeout.connect(flashed)

func _process(delta: float):
	global_position+=direction*SPEED*delta
	
	

func start(dir: Vector2):
	direction = dir
	rotation = direction.angle()
	var tween = create_tween()
	tween.tween_property(self, "SPEED", 0, 0.5)
	print("FLASH")

func register_collision():
	queue_free()

func flashed():
	if is_multiplayer_authority():
		flash_time.timeout.connect(flash_timeout)
		flash.self_modulate.a = 1
		var tween = create_tween()
		tween.tween_property(flash, "self_modulate", 0, 0.8)
		

func flash_timeout():
	pass
