extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos



var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
func _process(delta):
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !SigBank.is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")

	if SigBank.is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		SigBank.is_roaming = false
		SigBank.is_chatting = true
		$AnimatedSprite2D.play("idle")
		start_dialogue()
		
func start_dialogue():
	var dialog = load("res://dialogi/npc_1.dialogue")
	DialogueManager.show_example_dialogue_balloon(dialog,"start")
	
	
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !SigBank.is_chatting:
		position += dir * speed * delta
func _on_dialogue_ended():
	SigBank.is_chatting = false
	if !player_in_chat_zone:
		SigBank.is_roaming = true
				


func _on_chat_detection_area_body_entered(body):
	if body.name == "postac":
		player = body
		player_in_chat_zone = true


func _on_chat_detection_area_body_exited(body):
	if body.name == "postac":
		player_in_chat_zone = false
		_on_dialogue_ended()
		

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])



@onready var idle_dialogue = preload("res://dialogi/npc_idle.dialogue")

func _on_self_talk_timer_timeout():
	if SigBank.is_chatting or player_in_chat_zone:
		return

	SigBank.is_chatting = true
	SigBank.is_roaming = false

	DialogueManager.show_example_dialogue_balloon(idle_dialogue, "start")
	
	$SelfTalkTimer.wait_time = randf_range(60.0, 120.0)
	$SelfTalkTimer.start()
