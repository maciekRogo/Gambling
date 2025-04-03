extends GutTest

var slot_machine

	
func before_each():
	slot_machine = load("res://Scene/slot_machine.tscn").instantiate()
	add_child(slot_machine)
		
	if slot_machine.has_node("betAmount"):
		slot_machine.get_node("betAmount").value = 10
		

func after_each():
	slot_machine.queue_free()
	await get_tree().process_frame 

func test_calculateWinning_no_match():
	slot_machine.reel_result1 = 1
	slot_machine.reel_result2 = 2
	slot_machine.reel_result3 = 3

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, -10, "Brak dopasowania powinien zwrócić -bet_value")

func test_calculateWinning_two_match():
	slot_machine.reel_result1 = 2
	slot_machine.reel_result2 = 2
	slot_machine.reel_result3 = 3

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, 50, "Dwa pasujące symbole powinny dać bet_value * 5")

func test_calculateWinning_three_match():
	slot_machine.reel_result1 = 7
	slot_machine.reel_result2 = 7
	slot_machine.reel_result3 = 7

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, 1000, "Trzy pasujące symbole powinny dać bet_value * 100")

func test_receiveNumber_reel1():
	slot_machine._receiveNumber(1, 7)

	assert_eq(slot_machine.reel_result1, 7, "reel_result1 powinno mieć wartość 7")
	assert_eq(slot_machine.receivedHowManyTimes, 1, "receivedHowManyTimes powinno wzrosnąć do 1")

func test_receiveNumber_reel2():
	slot_machine._receiveNumber(2, 5)

	assert_eq(slot_machine.reel_result2, 5, "reel_result2 powinno mieć wartość 5")
	assert_eq(slot_machine.receivedHowManyTimes, 1, "receivedHowManyTimes powinno wzrosnąć do 1")

func test_receiveNumber_reel3():
	slot_machine._receiveNumber(3, 3)

	assert_eq(slot_machine.reel_result3, 3, "reel_result3 powinno mieć wartość 3")
	assert_eq(slot_machine.receivedHowManyTimes, 1, "receivedHowManyTimes powinno wzrosnąć do 1")
	
