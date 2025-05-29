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

# ---------------------
# TESTY JEDNOSTKOWE
# ---------------------

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
	
func test_calculateWinning_edge_case_two_last_match():
	slot_machine.reel_result1 = 3
	slot_machine.reel_result2 = 7
	slot_machine.reel_result3 = 7

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, 50, "Dwa ostatnie pasujące symbole powinny dać bet_value * 5")

func test_calculateWinning_all_zero():
	slot_machine.reel_result1 = 0
	slot_machine.reel_result2 = 0
	slot_machine.reel_result3 = 0

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, 1000, "Trzy zera również są trzema pasującymi symbolami")

func test_calculateWinning_invalid_reel_values():
	slot_machine.reel_result1 = null
	slot_machine.reel_result2 = 2
	slot_machine.reel_result3 = 2

	slot_machine._calculateWinning()

	assert_eq(slot_machine.bet_result, -10, "Nieprawidłowa wartość (null) powinna skutkować przegraną")

func test_calculateWinning_updates_money_on_win():
	SigBank.money = 100
	slot_machine.reel_result1 = 7
	slot_machine.reel_result2 = 7
	slot_machine.reel_result3 = 7

	slot_machine._calculateWinning()

	assert_eq(SigBank.money, 100 + 1000, "Powinno dodać nagrodę do pieniędzy")

func test_calculateWinning_updates_money_on_loss():
	SigBank.money = 100
	slot_machine.reel_result1 = 1
	slot_machine.reel_result2 = 2
	slot_machine.reel_result3 = 3

	slot_machine._calculateWinning()

	assert_eq(SigBank.money, 90, "Powinno odjąć bet_value przy przegranej")

func test_receiveNumber_full_cycle_and_reset():
	slot_machine._receiveNumber(1, 1)
	slot_machine._receiveNumber(2, 1)
	slot_machine._receiveNumber(3, 1)

	assert_eq(slot_machine.receivedHowManyTimes, 0, "Po 3 wynikach licznik powinien być zresetowany")
	assert_eq(slot_machine.reel_result1, 1, "reel_result1 powinno zostać ustawione")
	assert_eq(slot_machine.reel_result2, 1, "reel_result2 powinno zostać ustawione")
	assert_eq(slot_machine.reel_result3, 1, "reel_result3 powinno zostać ustawione")
	assert_eq(slot_machine.bet_result, 1000, "Po trzech trafieniach nagroda powinna zostać policzona")

func test_receiveNumber_multiple_cycles():
	for i in range(2):
		slot_machine._receiveNumber(1, 1)
		slot_machine._receiveNumber(2, 2)
		slot_machine._receiveNumber(3, 3)

	assert_eq(slot_machine.receivedHowManyTimes, 0, "Po 2 pełnych cyklach licznik nadal powinien być zresetowany")

func test_spin_button_insufficient_funds():
	SigBank.money = 5
	slot_machine.get_node("betAmount").value = 10

	slot_machine._on_spin_button_button_up()

	assert_eq(slot_machine.get_node("Result").text, "Brak pieniędzy!", "Powinien pojawić się komunikat o braku pieniędzy")

func test_spin_button_clears_result_text():
	SigBank.money = 100
	slot_machine.get_node("betAmount").value = 10
	slot_machine.get_node("Result").text = "Old result"

	slot_machine._on_spin_button_button_up()

	assert_eq(slot_machine.get_node("Result").text, "", "Powinien wyczyścić stary tekst wyniku")

# ---------------------
# TESTY INTEGRACYJNE
# ---------------------

func test_full_spin_cycle_updates_money_and_result_text():
	SigBank.money = 100
	slot_machine.get_node("betAmount").value = 10
	
	slot_machine._on_spin_button_button_up()
	
	assert_eq(slot_machine.get_node("Result").text, "", "Result powinno być wyczyszczone po spin")

	SigBank.rollFinished.emit(1, 7)
	SigBank.rollFinished.emit(2, 7)
	SigBank.rollFinished.emit(3, 7)
	
	assert_eq(slot_machine.bet_result, 1000, "Nagroda powinna być policzona jako bet_value * 100")
	assert_eq(SigBank.money, 1100, "Pieniądze powinny zostać powiększone o nagrodę")
	assert_eq(slot_machine.get_node("Result").text, "+ 1000", "Tekst wyniku powinien pokazać wygraną")

func test_spin_button_insufficient_funds_shows_message_and_no_spin():
	SigBank.money = 5
	slot_machine.get_node("betAmount").value = 10
	
	var old_bet_result = slot_machine.bet_result
	var old_money = SigBank.money
	
	slot_machine._on_spin_button_button_up()
	
	assert_eq(slot_machine.get_node("Result").text, "Brak pieniędzy!", "Powinien pojawić się komunikat o braku pieniędzy")
	assert_eq(slot_machine.bet_result, old_bet_result, "bet_result nie powinien się zmienić jeśli spin nie nastąpił")
	assert_eq(SigBank.money, old_money, "Pieniądze nie powinny się zmienić jeśli spin nie nastąpił")


func test_multiple_spins_and_resets():
	SigBank.money = 1000
	slot_machine.get_node("betAmount").value = 10
	
	for cycle in range(2):
		slot_machine._on_spin_button_button_up()
		
		SigBank.rollFinished.emit(1, 3 + cycle)
		SigBank.rollFinished.emit(2, 3 + cycle)
		SigBank.rollFinished.emit(3, 3 + cycle)
		
		assert_eq(slot_machine.receivedHowManyTimes, 0, "receivedHowManyTimes powinno się resetować po 3 wynikach")
	
