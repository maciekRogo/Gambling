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

# Called when the node enters the scene tree for the first time.
func _ready():
	$ZagrajPonownie.visible = false
	$WygranaTekst.visible = false
	get_tree().root.content_scale_factor
	# Create cards
	updateText()
	create_card_data()
	
	# Generate initial 2 player cards	
	await get_tree().create_timer(0.7).timeout
	generate_card("player")
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("player")
	updateText()
	
	# Generate dealers cards; note how first one is true as we want to show the back
	await get_tree().create_timer(0.5).timeout
	generate_card("dealer", true)
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("dealer")
	updateText()
	await get_tree().create_timer(1).timeout
	
	if playerScore == 21:
		playerWin(true)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_dobierz_pressed():

	generate_card("player")

	updateText()
	if playerScore == 21:
		_on_zostaw_pressed() # Player auto-stands on 21
	elif playerScore > 21:
		check_aces()  # Check to see if any 11-aces can convert to 1-aces
		if playerScore > 21:  # Score still surpasses 21
			playerLose()
			

func check_aces():
	# If player is over 21 and has any 11-aces, convert them to 1 so they stay under 21
	while playerScore > 21:
		ace_found = false
		for card_index in range(len(playerCards)):
			if playerCards[card_index][0] == 11:  # Ace with value 11
				playerCards[card_index][0] = 1  # Convert ace to 1
				ace_found = true
				break
		if not ace_found:
			break  # No more aces to convert, exit loop
		recalculate_player_score()
		updateText()
	
	
func recalculate_player_score():
	playerScore = 0
	for card in playerCards:
		playerScore += card[0]



func _on_zostaw_pressed():
	# Flip dealer's first card, dealer keeps hitting until score is above 16 or player's score
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true
	$tura.text = "Dealer's\nTurn"
	
	await get_tree().create_timer(0.5).timeout
	var dealer_hand_container = $Karty/Hands/Bot
	
	# Remove the first card from the container (the back of card texture)
	var child_to_remove = dealer_hand_container.get_child(0)
	child_to_remove.queue_free()  # Remove the node from the scene
	
	# Create a new TextureRect node for the card image
	var card = dealerCards[0]
	var card_texture_rect = TextureRect.new()
	var card_texture = ResourceLoader.load(card[1])
	card_texture_rect.texture = card_texture

	# Add the card as a child to the HBoxContainer
	dealer_hand_container.add_child(card_texture_rect)
	dealer_hand_container.move_child(card_texture_rect, 0)
	
	# Add score to dealerScore
	if card[0] == 11 and dealerScore > 10:  # Aces are 1 if score is too high for 11
		dealerScore += 1
	else:
		dealerScore += card[0]
	updateText()
	
	# Dealer hits until score surpasses player or 17
	while dealerScore < playerScore and dealerScore < 17:
		await get_tree().create_timer(1.5).timeout
		# Play "hit!" animation for dealer

		generate_card("dealer")
		updateText()
		
	# Evaluate results
	if dealerScore > 21 or dealerScore < playerScore:  # Dealer bust or dealer less than player
		playerWin()
	elif playerScore < dealerScore and dealerScore <= 21:  # Dealer is between player score and 22
		playerLose()
	else:  # Tie
		playerDraw()
	
	
func create_card_data():
	# Generate card names for ranks 2 to 10
	for rank in range(2, 11):
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(str(rank) + "_" + suit)
			card_values.append(rank)

	# Generate card names for face cards (jack, queen, king, ace)
	for face_card in ["jack", "queen", "king", "ace"]:
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(face_card + "_" + suit)
			if face_card != "ace":
				card_values.append(10)
			else:
				card_values.append(11)	
				
	
	# Load card values and image paths into the dictionary
	for card in range(len(card_names)):
		card_images[card_names[card]] = [card_values[card], 
			"res://assets/images/cards_pixel/" + card_names[card] + ".png"]
		
	#add the the of card image with key "back"
	card_images["back"] = [0, "res://assets/images/cards_alternatives/card_back_pix.png"]
	
	cardsShuffled = card_names.duplicate()
	cardsShuffled.shuffle()

	
func generate_card(hand, back=false):
	# Assuming you have already loaded card images into the dictionary as shown in your code
	var random_card

	# If back is true assign card image to back
	if back:
		random_card = card_images["back"]
		dealerCards.append(card_images[cardsShuffled.pop_back()])
	else:
		var random_card_name = cardsShuffled.pop_back()
		random_card = card_images[random_card_name] 

	# Create a new TextureRect node for card
	var card_texture = ResourceLoader.load(random_card[1])
	var card_texture_rect = TextureRect.new()
	card_texture_rect.texture = card_texture
	card_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	card_texture_rect.custom_minimum_size = Vector2(100, 100)  #

	# Get a reference to the existing HBoxContainer
	var card_hand_container
	if hand == "player":
		card_hand_container = $Karty/Hands/Gracz
		if random_card[0] == 11 and playerScore > 10:
			playerScore += 1
		else:
			playerScore += random_card[0]
		playerCards.append(random_card)
	elif hand == "dealer":
		card_hand_container = $Karty/Hands/Bot
		if random_card[0] == 11 and dealerScore > 10:
			dealerScore += 1
		else:
			dealerScore += random_card[0]
		dealerCards.append(random_card)
	else:
		return

	card_hand_container.add_child(card_texture_rect)



func updateText():
	# Update the labels displayed on screen for the dealer and player scores.
	$BotWynik.text = str(dealerScore)
	$GraczWynik.text = str(playerScore)


func playerLose():
	# Player has lost: display red text, disable buttons, ask to play again
	$WygranaTekst.text = "DEALER\nWINS"
	$WygranaTekst.set("theme_override_colors/font_color", "ff5342")
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true
	await get_tree().create_timer(1).timeout
	$WygranaTekst.visible = true
	await get_tree().create_timer(0.5).timeout
	$ZagrajPonownie.visible = true
	
	
func playerWin(blackjack=false):
	# Player has won: display text (already set if not blackjack),
	# display buttons and ask to play again
	if blackjack:
		$WygranaTekst.text = "PLAYER WINS\nBY BLACKJACK"
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true

	
	await get_tree().create_timer(1).timeout
	$WygranaTekst.visible = true
	await get_tree().create_timer(0.5).timeout
	$ZagrajPonownie.visible = true
	
	
func playerDraw():
	# Nobody wins: display white text, disable buttons and ask to play again
	$WygranaTekst.text = "DRAW"
	$WygranaTekst.set("theme_override_colors/font_color", "white")
	$Buttons/VBoxContainer/Dobierz.disabled = true
	$Buttons/VBoxContainer/Zostaw.disabled = true
	await get_tree().create_timer(1).timeout
	$WygranaTekst.visible = true
	await get_tree().create_timer(0.5).timeout
	$ZagrajPonownie.visible = true


func _on_Wyjdz_pressed():
	get_tree().change_scene_to_file("res://Scene/blackjack_gra.tscn")


func _on_ZagrajPonownie_pressed():
	get_tree().change_scene_to_file("res://Scene/blackjack_game.tscn")

func playerHasAce(cards):
	for card in cards:
		if card[0] == 11:
			return true
	return false
