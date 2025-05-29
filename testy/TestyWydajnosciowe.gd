extends Node

var test_start_time
var wheel

func _ready():
	print("\n==============================")
	print("== URUCHAMIANIE TESTÓW WYDAJNOŚCIOWYCH BLACKJACK ==")
	print("==============================\n")

	var blackjack_scene = preload("res://Scene/blackjack_game.tscn").instantiate()
	add_child(blackjack_scene)
	await get_tree().process_frame  

	test_create_card_data(blackjack_scene)
	test_generate_cards(blackjack_scene)
	test_full_game_simulation(blackjack_scene)

	print("\n==============================")
	print("== TESTY BLACKJACK ZAKOŃCZONE ==")
	print("==============================\n")

	print("\n==============================")
	print("== URUCHAMIANIE TESTÓW WYDAJNOŚCIOWYCH DLA SLOTU ==")
	print("==============================\n")

	var slot_scene = preload("res://Scene/reel.tscn").instantiate()
	add_child(slot_scene)
	await get_tree().process_frame

	await test_start_roll(slot_scene)
	await test_full_roll_cycle(slot_scene)
	await test_massive_rolls()

	print("\n==============================")
	print("== TESTY SLOTU ZAKOŃCZONE ==")
	print("==============================\n")

	print("\n==============================")
	print("== URUCHAMIANIE TESTÓW WYDAJNOŚCIOWYCH RULETKI ==")
	print("==============================\n")

	var roulette_scene = preload("res://Scene/roulette.tscn").instantiate()
	add_child(roulette_scene)
	wheel = roulette_scene.get_node("wheel")
	await get_tree().process_frame

	await test_start_spin(wheel)
	await test_spin_until_stop(wheel)
	await test_massive_spins()

	print("\n==============================")
	print("== TESTY RULETKI ZAKOŃCZONE ==")
	print("==============================\n")


func test_start_roll(scene):
	test_start_time = Time.get_ticks_msec()
	scene._startRoll(scene.reelID, 3.0)
	await get_tree().process_frame
	var duration = Time.get_ticks_msec() - test_start_time
	print("Czas wykonania _startRoll(): ", duration, " ms")

func test_full_roll_cycle(scene):
	scene._startRoll(scene.reelID, 1.0)
	var start_time = Time.get_ticks_msec()
	
	while scene.state != scene.STOP:
		scene._process(0.016) 
		await get_tree().process_frame

	var duration = Time.get_ticks_msec() - start_time
	print("Czas pełnego obrotu i zatrzymania: ", duration, " ms")

func test_massive_rolls():
	var total_time = 0
	var reels_to_test = 100
	
	for i in range(reels_to_test):
		var reel_instance = preload("res://Scene/reel.tscn").instantiate()
		reel_instance.reelID = i
		add_child(reel_instance)
		await get_tree().process_frame
		
		reel_instance._startRoll(reel_instance.reelID, 0.5)
		var t0 = Time.get_ticks_msec()
		
		while reel_instance.state != reel_instance.STOP:
			reel_instance._process(0.016)
			await get_tree().process_frame
		
		total_time += Time.get_ticks_msec() - t0
		remove_child(reel_instance)
		reel_instance.queue_free()
	
	print("Czas 100 obrotów: ", total_time, " ms")
	print("Średni czas jednego obrotu: ", total_time / reels_to_test, " ms")

func test_create_card_data(scene):
	test_start_time = Time.get_ticks_msec()
	scene.create_card_data()
	var duration = Time.get_ticks_msec() - test_start_time
	print("Czas wykonania create_card_data(): ", duration, " ms")

func test_generate_cards(scene):
	scene.create_card_data()
	var start_time = Time.get_ticks_msec()
	
	for i in range(52):
		scene.generate_card("player")
		scene.generate_card("dealer")
	
	var duration = Time.get_ticks_msec() - start_time
	print("Czas wygenerowania 104 kart (52 dla gracza i 52 dla bota): ", duration, " ms")

func test_full_game_simulation(scene):
	scene.create_card_data()
	var total_time = 0
	var games = 1000
	
	for i in range(games):
		var t0 = Time.get_ticks_msec()
		scene.cardsShuffled = scene.card_names.duplicate()
		scene.cardsShuffled.shuffle()

		scene.playerScore = 0
		scene.dealerScore = 0
		scene.playerCards.clear()
		scene.dealerCards.clear()
		
		scene.generate_card("player")
		scene.generate_card("player")
		scene.generate_card("dealer", true)
		scene.generate_card("dealer")
		
		scene.recalculate_player_score()
		total_time += Time.get_ticks_msec() - t0
	
	print("Czas 1000 gier: ", total_time, " ms")
	print("Średni czas jednej gry: ", total_time / games, " ms")

func test_start_spin(scene):
	test_start_time = Time.get_ticks_msec()
	scene.selected_number = 17  
	scene.bet_input = LineEdit.new()
	scene.bet_input.text = "100"
	SigBank.money = 1000

	scene.on_start_button_pressed()
	await get_tree().process_frame

	var duration = Time.get_ticks_msec() - test_start_time
	print("Czas rozpoczęcia spinowania: ", duration, " ms")


func test_spin_until_stop(scene):
	scene.selected_number = 17
	scene.bet_input = LineEdit.new()
	scene.bet_input.text = "100"
	SigBank.money = 1000

	scene.on_start_button_pressed()

	var start_time = Time.get_ticks_msec()
	while scene.spinning:
		scene._process(0.016)
		await get_tree().process_frame
	var duration = Time.get_ticks_msec() - start_time
	print("Czas pełnego spinowania i zatrzymania: ", duration, " ms")


func test_massive_spins():
	var total_time = 0
	var spins = 100

	for i in range(spins):
		var roulette_instance = preload("res://Scene/roulette.tscn").instantiate()
		add_child(roulette_instance)
		wheel = roulette_instance.get_node("wheel")
		await get_tree().process_frame

		wheel.selected_number = 17
		wheel.bet_input = LineEdit.new()
		wheel.bet_input.text = "100"
		SigBank.money = 1000000

		wheel.on_start_button_pressed()
		var t0 = Time.get_ticks_msec()

		while wheel.spinning:
			wheel._process(0.016)
			await get_tree().process_frame

		total_time += Time.get_ticks_msec() - t0
		remove_child(wheel)
		wheel.queue_free()

	print("Czas 100 spinów: ", total_time, " ms")
	print("Średni czas jednego spinu: ", total_time / spins, " ms")
