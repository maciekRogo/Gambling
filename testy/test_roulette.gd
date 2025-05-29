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

# ---------------------
# TESTY JEDNOSTKOWE
# ---------------------

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
	wheel.rotation = 0  
	wheel.spinning = false
	wheel.determine_result()
	assert_eq(SigBank.money, 500)

	wheel.selected_number = "EVEN"
	wheel.current_bet = 100
	SigBank.money = 500
	wheel.rotation = TAU - wheel.angle_per_number * 2  
	wheel.determine_result()
	assert_eq(SigBank.money, 500)

	wheel.selected_number = "EVEN"
	wheel.current_bet = 100
	SigBank.money = 500
	wheel.rotation = TAU - wheel.angle_per_number * 1 
	wheel.determine_result()
	assert_eq(SigBank.money, 700)

func test_even_bet_wins_correctly():
	SigBank.money = 1000
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "50"
	wheel.selected_number = "EVEN"
	wheel.current_bet = 50
	wheel.rotation = TAU - wheel.angle_per_number * 1  
	wheel.determine_result()
	assert_eq(SigBank.money, 1100)

func test_red_and_black_win_correctly():
	wheel.current_bet = 100
	wheel.selected_number = "RED"
	SigBank.money = 1000
	wheel.rotation = TAU - wheel.angle_per_number * 3  
	wheel.determine_result()
	assert_eq(SigBank.money, 1200)

	wheel.current_bet = 100
	wheel.selected_number = "BLACK"
	SigBank.money = 1000
	wheel.rotation = TAU - wheel.angle_per_number * 2 
	wheel.determine_result()
	assert_eq(SigBank.money, 1200)

func test_bet_button_selection_changes_state():
	var test_button := Button.new()
	test_button.text = "17"
	scene.add_child(test_button)

	wheel.on_bet_button_pressed(test_button)
	assert_eq(wheel.selected_number, 17)
	assert_eq(wheel.selected_button, test_button)

	wheel.on_bet_button_pressed(test_button)
	assert_eq(wheel.selected_number, 17)

# ---------------------
# TESTY INTEGRACYJNE
# ---------------------

func test_valid_bet_and_number_reduces_money_and_starts_spin():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "200"
	wheel.selected_number = 7
	wheel.on_start_button_pressed()
	assert_eq(wheel.current_bet, 200)
	assert_true(wheel.spinning)
	assert_eq(SigBank.money, 800)

func test_spin_starts_and_stops_with_result():
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "100"
	wheel.selected_number = 5
	wheel.on_start_button_pressed()

	assert_true(wheel.spinning)
	assert_gt(wheel.spin_velocity, 0)

	var loops = 0
	while wheel.spinning and loops < 2000:
		wheel._process(0.016)
		loops += 1

	if wheel.spinning == false and wheel.current_bet != 0:
		wheel.determine_result()

	assert_false(wheel.spinning)
	assert_eq(wheel.current_bet, 0)

func test_full_game_win_on_correct_number():
	SigBank.money = 500
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "10"
	wheel.selected_number = 32  

	wheel.on_start_button_pressed()
	assert_true(wheel.spinning)

	wheel.rotation = TAU - wheel.angle_per_number * 1
	wheel.spin_velocity = 0
	wheel.spinning = false
	wheel.determine_result()

	assert_eq(SigBank.money, 500 - 10 + 370)
	assert_eq(wheel.current_bet, 0)
	assert_eq(wheel.selected_number, null)

func test_full_game_loss_on_wrong_number():
	SigBank.money = 500
	wheel.bet_input = scene.get_node("BetInput")
	wheel.bet_input.text = "20"
	wheel.selected_number = 1

	wheel.on_start_button_pressed()

	wheel.rotation = TAU - wheel.angle_per_number * 1 
	wheel.spin_velocity = 0
	wheel.spinning = false
	wheel.determine_result()

	assert_eq(SigBank.money, 480)
	assert_eq(wheel.current_bet, 0)
	assert_eq(wheel.selected_number, null)
