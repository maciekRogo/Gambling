extends Control

var card_names = []
var card_values = []
var card_images = {}

var playerScore = 0
var dealerScore = 0
var playerCards = []
var dealerCards = []

var cardsShuffled = {}

var ace_found
var current_bet = 0

func _ready():
	$ZagrajPonownie.visible = false
	$WygranaTekst.visible = false
	$Buttons/VBoxContainer/Dobierz.disabled = false
	$Buttons/VBoxContainer/Zostaw.disabled = false
	create_card_data()
	updateText()

func _on_Start_pressed():
	print("Start wciśnięty!")

	var bet_input = $Buttons/VBoxContainer/BetInput
	var bet_text = bet_input.text.strip_edges()
	print("Odczytany tekst:", bet_text)

	if bet_text.is_valid_int():
		var bet = int(bet_text)
		if bet > 0 and bet <= SigBank.money:
			current_bet = bet
			SigBank.modify_money(-current_bet)
			print("USTAWIONY ZAKŁAD: ", current_bet)

			$Start.disabled = true
			$Buttons/VBoxContainer/Dobierz.disabled = false
			$Buttons/VBoxContainer/Zostaw.disabled = false

			start_game()
		else:
			$WygranaTekst.text = "Invalid bet!"
			$WygranaTekst.set("theme_override_colors/font_color", Color.RED)
			$WygranaTekst.visible = true
	else:
		$WygranaTekst.text = "Enter a valid number"
		$WygranaTekst.set("theme_override_colors/font_color", Color.RED)
		$WygranaTekst.visible = true
	

func start_game():
	var bet_input = $Buttons/VBoxContainer/BetInput
	var bet_text = bet_input.text.strip_edges()
	print("Odczytany tekst:", bet_text)

	if bet_text.is_valid_int():
		var bet = int(bet_text)
		if bet > 0 and bet <= SigBank.money:
			current_bet = bet
			SigBank.modify_money(-current_bet)
			print("USTAWIONY ZAKŁAD: ", current_bet)
	print("Kasa po postawieniu zakładu:", SigBank.money)

	# Resetujemy stan gry
	playerScore = 0
	dealerScore = 0
	playerCards.clear()
	dealerCards.clear()
	for child in $Karty/Hands/Gracz.get_children():
		child.queue_free()

	for child in $Karty/Hands/Bot.get_children():
		child.queue_free()

	updateText()

	await get_tree().create_timer(0.7).timeout
	generate_card("player")
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("player")
	updateText()

	await get_tree().create_timer(0.5).timeout
	generate_card("dealer", true)
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("dealer")
	updateText()
	await get_tree().create_timer(1).timeout

	if playerScore == 21:
		playerWin(true)

func _on_dobierz_pressed():
	generate_card("player")
	updateText()
	if playerScore == 21:
		_on_zostaw_pressed()
	elif playerScore > 21:
		check_aces()
		if playerScore > 21:
			playerLose()

func check_aces():
	while playerScore > 21:
		ace_found = false
		for card_index in range(len(playerCards)):
			if playerCards[card_index][0] == 11:
				playerCards[card_index][0] = 1
				ace_found = true
				break
		if not ace_found:
			break
		recalculate_player_score()
		updateText()

func recalculate_player_score():
	playerScore = 0
	for card in playerCards:
		playerScore += card[0]

func _on_zostaw_pressed():
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true
	$tura.text = "Dealer's\nTurn"

	await get_tree().create_timer(0.5).timeout
	var dealer_hand_container = $Karty/Hands/Bot
	dealer_hand_container.get_child(0).queue_free()

	var card = dealerCards[0]
	var card_texture_rect = TextureRect.new()
	var card_texture = ResourceLoader.load(card[1])
	card_texture_rect.texture = card_texture
	dealer_hand_container.add_child(card_texture_rect)
	dealer_hand_container.move_child(card_texture_rect, 0)

	if card[0] == 11 and dealerScore > 10:
		dealerScore += 1
	else:
		dealerScore += card[0]
	updateText()

	while dealerScore < playerScore and dealerScore < 17:
		await get_tree().create_timer(1.5).timeout
		generate_card("dealer")
		updateText()

	if dealerScore > 21 or dealerScore < playerScore:
		playerWin()
	elif playerScore < dealerScore and dealerScore <= 21:
		playerLose()
	else:
		playerDraw()

func playerWin(blackjack=false):
	if blackjack:
		$WygranaTekst.text = "PLAYER WINS\nBY BLACKJACK"
	else:
		$WygranaTekst.text = "PLAYER WINS"
	print("Dodaję pieniądze: ", current_bet * 2)
	SigBank.modify_money(current_bet * 2)
	print("Kasa po wygranej:", SigBank.money)
	end_game("green")


func playerDraw():
	$WygranaTekst.text = "DRAW"
	print("Zwracam pieniądze: ", current_bet)
	SigBank.modify_money(current_bet)
	print("Kasa po remisie:", SigBank.money)
	end_game("white")


func playerLose():
	$WygranaTekst.text = "DEALER\nWINS"
	print("Gracz przegrał, kasa zostaje: ", SigBank.money)
	end_game("red")

func end_game(color):
	$WygranaTekst.set("theme_override_colors/font_color", Color(color))
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true
	await get_tree().create_timer(1).timeout
	$WygranaTekst.visible = true
	await get_tree().create_timer(0.5).timeout
	$ZagrajPonownie.visible = true

func create_card_data():
	for rank in range(2, 11):
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(str(rank) + "_" + suit)
			card_values.append(rank)
	for face_card in ["jack", "queen", "king", "ace"]:
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(face_card + "_" + suit)
			card_values.append(10 if face_card != "ace" else 11)
	for card in range(len(card_names)):
		card_images[card_names[card]] = [card_values[card],
			"res://assets/images/cards_pixel/" + card_names[card] + ".png"]
	card_images["back"] = [0, "res://assets/images/cards_alternatives/card_back_pix.png"]
	cardsShuffled = card_names.duplicate()
	cardsShuffled.shuffle()

func generate_card(hand, back=false):
	var random_card
	if back:
		random_card = card_images["back"]
		dealerCards.append(card_images[cardsShuffled.pop_back()])
	else:
		var random_card_name = cardsShuffled.pop_back()
		random_card = card_images[random_card_name]

	var card_texture = ResourceLoader.load(random_card[1])
	var card_texture_rect = TextureRect.new()
	card_texture_rect.texture = card_texture
	card_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	card_texture_rect.custom_minimum_size = Vector2(100, 100)

	var card_hand_container
	if hand == "player":
		card_hand_container = $Karty/Hands/Gracz
		playerScore += (1 if random_card[0] == 11 and playerScore > 10 else random_card[0])
		playerCards.append(random_card)
	elif hand == "dealer":
		card_hand_container = $Karty/Hands/Bot
		dealerScore += (1 if random_card[0] == 11 and dealerScore > 10 else random_card[0])
		dealerCards.append(random_card)
	else:
		return
	card_hand_container.add_child(card_texture_rect)

func updateText():
	$BotWynik.text = str(dealerScore)
	$GraczWynik.text = str(playerScore)

func _on_Wyjdz_pressed():
	get_tree().change_scene_to_file("res://Scene/blackjack_gra.tscn")

func _on_ZagrajPonownie_pressed():
	get_tree().change_scene_to_file("res://Scene/blackjack_game.tscn")

func playerHasAce(cards):
	for card in cards:
		if card[0] == 11:
			return true
	return false
