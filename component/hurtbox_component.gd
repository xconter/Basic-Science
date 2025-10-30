class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent 
@onready var progress_bar: ProgressBar = $"../ProgressBar"

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area : Area2D):
	if !is_multiplayer_authority() or other_area is not HitboxComponent:
		return
	
	var hitbox_component: HitboxComponent = other_area
	hitbox_component._register_hurtbox_hit(self)
	health_component.damage(hitbox_component.damage)
	progress_bar.set_value_no_signal(progress_bar.value-hitbox_component.damage)
	
