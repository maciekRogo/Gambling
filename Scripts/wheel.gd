extends Sprite2D

var spinning = false
var spin_velocity = 0.0
var friction = 0.995

var numbers_on_wheel := [
	0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23,
	10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
]

var total_numbers := 37
var angle_per_number := TAU / total_numbers

var selected_button = null
var selected_number = null
var current_bet := 0

var bet_input


func _ready():
	self.centered

	var start_button = $"../Button"
	start_button.pressed.connect(on_start_button_pressed)

	bet_input = get_parent().get_node("BetInput")
	
	var buttons_container = get_parent().get_node("GridContainer")
	for vbox in buttons_container.get_children():
		for button in vbox.get_children():
			if button is Button:
				button.pressed.connect(Callable(self, "on_bet_button_pressed").bind(button))
	
	var buttons_container2 = get_parent().get_node("GridContainer2")
	for hbox in buttons_container2.get_children():
		for button in hbox.get_children():
			if button is Button:
				button.pressed.connect(Callable(self, "on_bet_button_pressed").bind(button))
				
	var buttons_container3 = get_parent().get_node("GridContainer3")
	for hbox in buttons_container3.get_children():
		for button in hbox.get_children():
			if button is Button:
				button.pressed.connect(Callable(self, "on_bet_button_pressed").bind(button))


func _process(delta):
	if spinning:
		if spin_velocity != 0:
			rotation += spin_velocity * delta
			spin_velocity *= friction
			if abs(spin_velocity) < 0.01:
				spin_velocity = 0
				spinning = false
				determine_result()


func on_start_button_pressed():
	if selected_number == null:
		print("Wybierz najpierw numer lub typ zakładu!")
		return
	if spinning:
		print("Koło już się kręci!")
		return


	var bet_text = bet_input.text.strip_edges()
	if not bet_text.is_valid_int():
		print("Podaj poprawną wartość zakładu!")
		return
	current_bet = int(bet_text)
	
	if current_bet <= 0:
		print("Zakład musi być większy od 0!")
		return
	if current_bet > SigBank.money:
		print("Nie masz tyle pieniędzy!")
		return
	
	SigBank.modify_money(-current_bet)
	print("Zakład postawiony: ", current_bet)
	print("Pieniądze po zakładzie: ", SigBank.money)
	
	spin_velocity = randf_range(20.0, 30.0)
	spinning = true
	print("Koło się kręci...")
	$"../Button".disabled = true

func on_bet_button_pressed(button):
	if spinning:
		print("Nie możesz obstawiać w trakcie kręcenia koła!")
		return
	
	if selected_button:
		selected_button.remove_theme_stylebox_override("normal")

	selected_button = button
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 1, 0, 0.5)
	selected_button.add_theme_stylebox_override("normal", style)

	var text = button.text.strip_edges()
	if text.is_valid_int():
		selected_number = int(text)
	else:
		selected_number = text  # np. EVEN, RED, 1-18 itd.

	print("Obstawiono: ", selected_number)


func determine_result():
	$"../Button".disabled = false
	var normalized_rotation = fmod(rotation, TAU)
	if normalized_rotation < 0:
		normalized_rotation += TAU

	var winning_index = int(round(total_numbers - normalized_rotation / angle_per_number)) % total_numbers
	var winning_number = numbers_on_wheel[winning_index]

	print("Wypadła liczba: ", winning_number)

	var win = false
	var payout = 0

	match typeof(selected_number):
		TYPE_INT:
			win = (winning_number == selected_number)
			payout = current_bet * 37
		TYPE_STRING:
			match selected_number:
				"EVEN":
					win = winning_number != 0 and winning_number % 2 == 0
					payout = current_bet * 2
				"ODD":
					win = winning_number % 2 == 1
					payout = current_bet * 2
				"RED":
					win = is_red(winning_number)
					payout = current_bet * 2
				"BLACK":
					win = is_black(winning_number)
					payout = current_bet * 2
				"1-18":
					win = winning_number >= 1 and winning_number <= 18
					payout = current_bet * 2
				"19-36":
					win = winning_number >= 19 and winning_number <= 36
					payout = current_bet * 2
				"1st 12":
					win = winning_number >= 1 and winning_number <=12
					payout = current_bet * 3
				"2nd 12":
					win = winning_number >= 12 and winning_number <=24
					payout = current_bet * 3
				"3rd 12":
					win = winning_number >= 24 and winning_number <=36
					payout = current_bet * 3 
					
				_:
					print("Nieobsługiwany typ zakładu:", selected_number)
		_:
			print("Błąd typu zakładu.")

	if win:
		SigBank.modify_money(payout)
		print("WYGRAŁEŚ! Wygrana: ", payout)
	else:
		print("Przegrałeś. Strata: ", current_bet)

	print("Stan pieniędzy: ", SigBank.money)

	if selected_button:
		selected_button.remove_theme_stylebox_override("normal")
	selected_button = null
	selected_number = null
	current_bet = 0


func is_red(number):
	return number in [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]

func is_black(number):
	return number in [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]
