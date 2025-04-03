extends Node2D

@export var slot_item_count: int = 10
@export var sprite_size: int = 16
@export var reelID: int

@onready var reel1: Sprite2D = $reelImage1
@onready var reel2: Sprite2D = $reelImage2

var tween: Tween
var move_speed: float = 20.0
var state: int = STOP  

enum { ROLL, STOP, ROLLBACK }

var roll_duration: float = 3.0
var roll_back_duration: float = 0.5

func _ready() -> void:
	SigBank.startRoll.connect(Callable(self, "_startRoll"))
	reel1.position.y = -1000
	reel2.position.y = 0

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		_startRoll(reelID, 5)
		print("rollMe")

	match state:
		ROLLBACK:
			_move_reels(-move_speed)
			roll_back_duration -= delta
			if roll_back_duration <= 0:
				state = ROLL
		ROLL:
			_move_reels(move_speed)
			roll_duration -= delta
			if roll_duration <= 0:
				state = STOP
				_stopRoll()
		STOP:
			pass

func _startRoll(reelNumber: int, duration: float) -> void:
	if reelNumber != reelID:
		return
	
	reel1.position.y = -1000
	reel2.position.y = 0
	state = ROLLBACK
	roll_duration = duration
	roll_back_duration = 0.25
	print(reelID, reelNumber, duration)

func _move_reels(speed: float) -> void:
	_scroll_reel(reel1, speed)
	_scroll_reel(reel2, speed)

func _scroll_reel(reel: Sprite2D, speed: float) -> void:
	reel.position.y += speed
	if reel.position.y >= 1000:
		reel.position.y = -1000

func _stopRoll() -> void:	
	tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	var rng: int = randi_range(0, 9)
	var duration: float = 1.5
	var final_pos: float = -100 * rng
	
	var top_reel: Sprite2D = reel1 if reel1.position.y < reel2.position.y else reel2
	var bottom_reel: Sprite2D = reel1 if top_reel == reel2 else reel2
	
	top_reel.z_index = 1
	bottom_reel.z_index = 0

	tween.tween_property(top_reel, "position:y", final_pos, duration)
	tween.tween_property(bottom_reel, "position:y", final_pos + 1000, duration)

	await tween.finished
	print("Reel ID:", reelID, " Reel Image:", top_reel.name, " Position:", final_pos, " RNG:", rng)
	SigBank.rollFinished.emit(reelID, rng)
