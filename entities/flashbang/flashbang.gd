class_name Flashbang
extends Node2D


@onready var time_until_flash: Timer = $TimeUntilFlash
@onready var flash_time: Timer = $FlashTime

const SOLID_WHITE = preload("res://entities/flashbang/Solid_white.png")
#var image: Image = SOLID_WHITE

func _ready() -> void:
	pass
