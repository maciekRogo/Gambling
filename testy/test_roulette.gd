extends GutTest

var scene
var wheel

func before_each():
	scene = preload("res://Scene/roulette.tscn").instantiate()
	add_child(scene)
	wheel = scene.get_node("wheel")
	SigBank.money = 1000

func after_each():
	scene.queue_free()

func test_invalid_bet_text_shows_error():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "abc"
	wheel.selected_number = 5
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 0)

func test_no_selected_number_blocks_game_start():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "100"
	wheel.selected_number = null
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 0)

func test_valid_bet_and_number_reduces_money_and_starts_spin():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "200"
	wheel.selected_number = 7
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 200)
	assert_true(wheel.spinning)
	assert_eq(SigBank.money, 800)

func test_bet_exceeds_money_shows_error():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "1500"
	wheel.selected_number = 5
	wheel.on_start_button_pressed()
	assert_false(wheel.spinning)
	assert_eq(SigBank.money, 1000)

func test_zero_bet_is_rejected():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "0"
	wheel.selected_number = 7
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 0)
	assert_false(wheel.spinning)

func test_cannot_start_while_spinning():
	wheel.spinning = true
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "100"
	wheel.selected_number = 3
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 0)

func test_even_bet_win():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "100"
	wheel.selected_number = "EVEN"
	wheel.current_bet = 100
	SigBank.money = 500
	wheel.rotation = 0  # 0 na kole to liczba 0 (czyli nieparzysta)
	wheel.spinning = false
	wheel.determine_result()
	# Zakład przegrany, bo 0 nie jest EVEN
	assert_eq(SigBank.money, 500)

	wheel.selected_number = "EVEN"
	wheel.current_bet = 100
	SigBank.money = 500
	wheel.rotation = TAU - wheel.angle_per_number * 2  # indeks 2 -> liczba 15 (nieparzysta)
	wheel.determine_result()
	assert_eq(SigBank.money, 500)

	wheel.selected_number = "EVEN"
	wheel.current_bet = 100
	SigBank.money = 500
	wheel.rotation = TAU - wheel.angle_per_number * 1  # indeks 1 -> liczba 32 (parzysta)
	wheel.determine_result()
	assert_eq(SigBank.money, 700)
