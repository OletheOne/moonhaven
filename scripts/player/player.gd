extends CharacterBody2D

const WALK_SPEED := 80.0
const RUN_SPEED := 140.0

enum Facing { DOWN, UP, LEFT, RIGHT }

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _facing: Facing = Facing.DOWN


func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input.length_squared() > 0.0:
		input = input.normalized()
		_update_facing(input)

	var speed := RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	velocity = input * speed
	move_and_slide()
	_update_animation(input.length_squared() > 0.0)


func _update_facing(input: Vector2) -> void:
	if absf(input.x) > absf(input.y):
		_facing = Facing.RIGHT if input.x > 0.0 else Facing.LEFT
	else:
		_facing = Facing.DOWN if input.y > 0.0 else Facing.UP


func _update_animation(is_moving: bool) -> void:
	var prefix := "walk" if is_moving else "idle"
	var animation_name := "%s_%s" % [prefix, _facing_to_suffix()]

	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func _facing_to_suffix() -> String:
	match _facing:
		Facing.DOWN:
			return "down"
		Facing.UP:
			return "up"
		Facing.LEFT:
			return "left"
		Facing.RIGHT:
			return "right"

	return "down"
