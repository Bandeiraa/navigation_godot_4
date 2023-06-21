extends CharacterBody2D
class_name Warrior

@export_category("Objects")
@export var _sprite: Sprite2D = null
@export var _animation: AnimationPlayer = null

@export_category("Variables")
@export var _move_speed: float = 128.0

func _physics_process(_delta: float) -> void:
	_move()
	_animate()
	
	
func _move() -> void:
	var _direction: Vector2 = Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down"
	).normalized()
	
	velocity = _direction * _move_speed
	move_and_slide()
	
	
func _animate() -> void:
	if velocity.x > 0:
		_sprite.flip_h = false
		
	if velocity.x < 0:
		_sprite.flip_h = true
		
	if velocity:
		_animation.play("walk")
		return
		
	_animation.play("idle")
