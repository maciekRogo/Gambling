extends Control

var reel_result1
var reel_result2
var reel_result3

var receivedHowManyTimes: int = 0

var bet_value: int
var bet_result: int
var winningMultiplier: int = 0

func _ready() -> void:
	SigBank.rollFinished.connect(_receiveNumber)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://Scene/mapatemplate_version2.tscn")

func _receiveNumber(reelID: int, rngResult: int) -> void:
	receivedHowManyTimes += 1
	
	match reelID:
		1: reel_result1 = rngResult
		2: reel_result2 = rngResult
		3: reel_result3 = rngResult

	if receivedHowManyTimes < 3:
		print(receivedHowManyTimes)
	else:
		receivedHowManyTimes = 0
		_calculateWinning()

func _calculateWinning() -> void:
	bet_value = int($betAmount.value)

	if reel_result1 == reel_result2 and reel_result2 == reel_result3:
		winningMultiplier = 100
	elif reel_result1 == reel_result2 or reel_result2 == reel_result3:
		winningMultiplier = 5
	else:
		winningMultiplier = -1

	bet_result = bet_value * winningMultiplier

	if bet_result > 0:
		SigBank.money += bet_result
	else:
		SigBank.money -= bet_value

	$Result.text = "+ " + str(bet_result) if bet_result > 0 else str(bet_result)

func _on_spin_button_button_up() -> void:
	bet_value = int($betAmount.value)
	
	if bet_value > SigBank.money:
		$Result.text = "Brak pieniędzy!"
		return

	$Result.text = "" 

	for id in range(1, 4):
		SigBank.startRoll.emit(id, 2.0 + (id - 1) * 0.5)

func _on_button_pressed() -> void:
	pass
