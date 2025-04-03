extends CharacterBody2D

@export var speed: float = 100.0

@onready var anim_sprite = $AnimatedSprite2D

var direction = Vector2.ZERO  # Aktualny kierunek ruchu

func _process(delta):
	get_input()
	move_and_slide()
	update_animation()

func get_input():
	direction = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		direction.y = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1

	direction = direction.normalized()
	velocity = direction * speed

func update_animation():
	if direction == Vector2.ZERO:
		if anim_sprite.animation.begins_with("walk"):
			anim_sprite.animation = anim_sprite.animation.replace("walk", "idle")
	else:
		if direction.x > 0:
			anim_sprite.animation = "walk_right"
		elif direction.x < 0:
			anim_sprite.animation = "walk_left"
		elif direction.y > 0:
			anim_sprite.animation = "walk_down"
		elif direction.y < 0:
			anim_sprite.animation = "walk_up"

	anim_sprite.play()
