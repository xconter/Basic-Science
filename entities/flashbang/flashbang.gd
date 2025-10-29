class_name Flashbang
extends Node2D

var SPEED: int = 600
@onready var time_until_flash: Timer = $TimeUntilFlash
@onready var flash_time: Timer = $FlashTime
var direction: Vector2
const SOLID_WHITE = preload("res://entities/flashbang/Solid_white.png")
#var image: Image = SOLID_WHITE

func _ready() -> void:
	pass

func _process(delta: float):
	global_position+=direction*SPEED*delta
	print(SPEED)

func start(dir: Vector2):
	direction = dir
	rotation = direction.angle()
	var tween = create_tween()
	tween.tween_property(self, "SPEED", 0, 0.5)
	var tween2 = create_tween()
	tween.tween_property(self, "scale", 2, 0.25)
	#var tween3 = 

func register_collision():
	queue_free()

func _on_life_timer_timeout():
	if is_multiplayer_authority():
		queue_free()
