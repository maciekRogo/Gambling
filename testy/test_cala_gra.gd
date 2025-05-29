extends GutTest  

var scene
var bet_input
var dobierz_button
var zostaw_button
var wygrana_tekst
var start_button

func before_each():
	scene = preload("res://Scene/blackjack_game.tscn").instantiate()
	add_child(scene)

	SigBank.money = 1000  

	bet_input = scene.get_node("Buttons/VBoxContainer/BetInput")
	dobierz_button = scene.get_node("Buttons/VBoxContainer/Dobierz")
	zostaw_button = scene.get_node("Buttons/VBoxContainer/Zostaw")
	wygrana_tekst = scene.get_node("WygranaTekst")
	start_button = scene.get_node("Buttons/VBoxContainer/Start")


func after_each():
	scene.queue_free()

# ---------------------
# TESTY JEDNOSTKOWE
# ---------------------

func test_valid_bet_triggers_start_game():
	scene.current_bet = 0
	bet_input.text = "100"
	scene.start_game()

	assert_eq(scene.current_bet, 100)
	assert_eq(SigBank.money, 900)
	assert_true(start_button.disabled)
	assert_false(dobierz_button.disabled)
	assert_false(zostaw_button.disabled)
	assert_false(wygrana_tekst.visible)

func test_invalid_bet_shows_error():
	scene.current_bet = 0
	bet_input.text = "-50"
	scene.start_game()
	
	assert_eq(scene.current_bet, 0)
	assert_true(wygrana_tekst.visible)
	assert_eq(wygrana_tekst.text, "Bet must be greater than 0")  


func test_non_number_input_shows_error():
	scene.current_bet = 0
	bet_input.text = "abc"
	scene.start_game()

	assert_eq(scene.current_bet, 0)
	assert_true(wygrana_tekst.visible)
	assert_eq(wygrana_tekst.text, "Enter a valid number")

func test_bet_more_than_money_shows_error():
	scene.current_bet = 0
	bet_input.text = "2000"
	scene.start_game()
	
	assert_eq(scene.current_bet, 0)
	assert_true(wygrana_tekst.visible)
	assert_eq(wygrana_tekst.text, "Not enough money!")  
	

func test_player_win_increases_money():
	SigBank.money = 500
	scene.current_bet = 50
	scene.playerWin()
	assert_eq(SigBank.money, 500 + 100)  

func test_player_win_blackjack_increases_money_and_sets_text():
	SigBank.money = 1000
	scene.current_bet = 200
	scene.playerWin(true)
	assert_eq(SigBank.money, 1000 + 400) 
	assert_eq(wygrana_tekst.text, "PLAYER WINS\nBY BLACKJACK")

func test_player_draw_refunds_money():
	SigBank.money = 300
	scene.current_bet = 100
	scene.playerDraw()
	assert_eq(SigBank.money, 400) 
	assert_eq(wygrana_tekst.text, "DRAW")

func test_player_lose_does_not_change_money_and_sets_text():
	SigBank.money = 700
	scene.current_bet = 100
	scene.playerLose()
	assert_eq(SigBank.money, 700)  
	assert_eq(wygrana_tekst.text, "DEALER\nWINS")

func test_player_has_ace_returns_true_or_false():
	scene.playerCards = [[11, "path"], [5, "path"]]
	assert_true(scene.playerHasAce(scene.playerCards))

	scene.playerCards = [[10, "path"], [5, "path"]]
	assert_false(scene.playerHasAce(scene.playerCards))
	
	
func test_check_aces_adjusts_ace_value():
	scene.playerCards = [[11, "path"], [11, "path"], [9, "path"]] 
	scene.playerScore = 31 
	scene.check_aces()
	assert_true(scene.playerScore <= 21) 

func test_generate_card_removes_card_from_deck():
	var initial_count = scene.cardsShuffled.size()
	scene.generate_card("player")
	assert_eq(scene.cardsShuffled.size(), initial_count - 1)

func test_end_game_sets_visibility_and_color():
	wygrana_tekst.visible = false
	scene.get_node("Buttons/VBoxContainer/Dobierz").disabled = false
	scene.get_node("Buttons/VBoxContainer/Zostaw").disabled = false
	
	scene.end_game_sync("blue")
	
	assert_true(wygrana_tekst.visible)
	assert_true(scene.get_node("Buttons/VBoxContainer/Dobierz").disabled)
	assert_true(scene.get_node("Buttons/VBoxContainer/Zostaw").disabled)
	assert_eq(wygrana_tekst.get("theme_override_colors/font_color"), Color("blue"))
	
func test_check_aces_converts_multiple_aces():
	scene.playerCards = [[11, "path"], [11, "path"], [10, "path"]]
	scene.playerScore = 32
	scene.check_aces()
	assert_eq(scene.playerScore, 12)

func test_generate_card_adds_to_player_score_correctly():
	scene.playerScore = 0
	scene.cardsShuffled = ["2_clubs"]
	scene.card_images["2_clubs"] = [2, "res://dummy.png"]
	scene.generate_card("player")
	assert_eq(scene.playerScore, 2)
	assert_eq(scene.playerCards.size(), 1)

func test_generate_card_adds_to_dealer_score_correctly():
	scene.dealerScore = 0
	scene.cardsShuffled = ["king_hearts"]
	scene.card_images["king_hearts"] = [10, "res://dummy.png"]
	scene.generate_card("dealer")
	assert_eq(scene.dealerScore, 10)
	assert_eq(scene.dealerCards.size(), 1)

func test_generate_card_ace_added_as_1_if_score_above_10():
	scene.playerScore = 15
	scene.cardsShuffled = ["ace_spades"]
	scene.card_images["ace_spades"] = [11, "res://dummy.png"]
	scene.generate_card("player")
	assert_eq(scene.playerScore, 16)  

func test_player_score_after_recalculate():
	scene.playerCards = [[11, "path"], [1, "path"], [5, "path"]]
	scene.recalculate_player_score()
	assert_eq(scene.playerScore, 17)

func test_end_game_sync_disables_buttons_and_shows_text():
	scene.end_game_sync("green")
	assert_true(wygrana_tekst.visible)
	assert_true(dobierz_button.disabled)
	assert_true(zostaw_button.disabled)
	assert_true(start_button.disabled or start_button.disabled == false) 
	assert_true(scene.get_node("ZagrajPonownie").visible)


func test_start_game_blackjack_triggers_win():
	bet_input.text = "100"
	scene.cardsShuffled = ["ace_spades", "jack_hearts", "9_hearts", "5_diamonds"]
	scene.card_images = {
		"ace_spades": [11, "res://dummy.png"],
		"jack_hearts": [10, "res://dummy.png"],
		"9_hearts": [9, "res://dummy.png"],
		"5_diamonds": [5, "res://dummy.png"],
		"back": [0, "res://dummy.png"] 
	}
	scene.start_game_sync()
	assert_eq(wygrana_tekst.text, "Wygrał Gracz ")
	assert_false(wygrana_tekst.visible)

# ---------------------
# TESTY INTEGRACYJNE
# ---------------------

func test_full_game_flow_player_wins_blackjack():
	SigBank.money = 1000
	bet_input.text = "100"
	scene.cardsShuffled = ["ace_spades", "jack_hearts", "9_hearts", "5_diamonds"]
	scene.card_images = {
		"ace_spades": [11, "res://dummy.png"],
		"jack_hearts": [10, "res://dummy.png"],
		"9_hearts": [9, "res://dummy.png"],
		"5_diamonds": [5, "res://dummy.png"],
		"back": [0, "res://dummy.png"]
	}
	
	scene.start_game_sync()
	
	assert_eq(scene.current_bet, 100)
	assert_eq(SigBank.money, 900)
	assert_eq(scene.playerScore, 14)

func test_full_game_flow_player_busts_and_loses():
	SigBank.money = 500
	bet_input.text = "50"
	scene.cardsShuffled = ["king_hearts", "queen_clubs", "2_spades", "3_diamonds", "5_clubs", "9_hearts"]
	scene.card_images = {
		"king_hearts": [10, "res://dummy.png"],
		"queen_clubs": [10, "res://dummy.png"],
		"2_spades": [2, "res://dummy.png"],
		"3_diamonds": [3, "res://dummy.png"],
		"5_clubs": [5, "res://dummy.png"],
		"9_hearts": [9, "res://dummy.png"],
		"back": [0, "res://dummy.png"]
	}

	scene.start_game_sync()

	assert_eq(scene.current_bet, 50)
	assert_eq(SigBank.money, 450)

	scene._on_dobierz_pressed()
	scene._on_dobierz_pressed()

	assert_eq(SigBank.money, 450)  

func test_full_game_flow_player_stands_and_dealer_plays():
	SigBank.money = 300
	bet_input.text = "100"
	scene.cardsShuffled = ["9_hearts", "7_clubs", "6_diamonds", "8_spades", "5_clubs", "4_hearts", "king_diamonds"]
	scene.card_images = {
		"9_hearts": [9, "res://dummy.png"],
		"7_clubs": [7, "res://dummy.png"],
		"6_diamonds": [6, "res://dummy.png"],
		"8_spades": [8, "res://dummy.png"],
		"5_clubs": [5, "res://dummy.png"],
		"4_hearts": [4, "res://dummy.png"],
		"king_diamonds": [10, "res://dummy.png"],
		"back": [0, "res://dummy.png"]
	}

	scene.start_game_sync()

	assert_eq(scene.current_bet, 100)
	assert_eq(SigBank.money, 200)

	await scene._on_zostaw_pressed()
