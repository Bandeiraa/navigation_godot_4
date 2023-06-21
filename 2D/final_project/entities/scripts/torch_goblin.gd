extends CharacterBody2D
class_name TorchGoblin

var _spawn_point: Vector2
var _target: Warrior = null
var _is_attacking: bool = false

@export_category("Objects")
@export var _sprite: Sprite2D = null
@export var _animation: AnimationPlayer = null
@export var _navigation_agent: NavigationAgent2D = null
@export var _respawn_timer: Timer = null

@export_category("Variables")
@export var _distance_threshold: float = 64.0
@export var _move_speed: float = 192.0

func _ready() -> void:
	_spawn_point = global_position
	
	
func _physics_process(_delta: float) -> void:
	if is_instance_valid(_target):
		_navigation_agent.set_target_position(_target.global_position)
		
	if _navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		_animate()
		return
		
	var _next_position: Vector2 = _navigation_agent.get_next_path_position()
	var _new_direction: Vector2 = global_position.direction_to(_next_position)
	
	if is_instance_valid(_target):
		var _new_distance: float = global_position.distance_to(_target.global_position)
		if not _new_distance > _distance_threshold:
			if not _is_attacking:
				_is_attacking = true
				
			_animate()
			return
			
	if not _is_attacking:
		_navigation_agent.set_velocity(_new_direction * _move_speed)
		
		
func _on_navigation_agent_velocity_computed(_safe_velocity: Vector2) -> void:
	velocity = _safe_velocity
	move_and_slide()
	_animate()
	
	
func _animate() -> void:
	if velocity.x > 0:
		_sprite.flip_h = false
		
	if velocity.x < 0:
		_sprite.flip_h = true
		
	if _is_attacking:
		_animation.play("attack")
		return
		
	if velocity != Vector2.ZERO:
		_animation.play("walk")
		return
		
	_animation.play("idle")
	
	
func _on_detection_area_body_entered(_body) -> void:
	if _body is Warrior:
		_target = _body
		
		if not _respawn_timer.is_stopped():
			_respawn_timer.stop()
			
			
func _on_detection_area_body_exited(_body) -> void:
	if _body is Warrior:
		_navigation_agent.set_target_position(global_position)
		_respawn_timer.start()
		_target = null
		
		
func _on_respawn_timer_timeout() -> void:
	_navigation_agent.set_target_position(_spawn_point)
	
	
func _on_animation_finished(_anim_name: String) -> void:
	_is_attacking = false
