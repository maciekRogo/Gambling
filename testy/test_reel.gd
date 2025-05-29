extends GutTest

var reel_scene = preload("res://Scene/reel.tscn") 
var reel 
var signal_emitted: bool = false
var emitted_reelID: int = -1
var emitted_rng: int = -1

func before_each():

	reel = reel_scene.instantiate()
	add_child(reel)
	
	await get_tree().process_frame  

func after_each():
	remove_child(reel)
	reel.queue_free()

# ---------------------
# TESTY JEDNOSTKOWE
# ---------------------

func test_initial_values():
	assert_eq(reel.state, reel.STOP, "Początkowy stan powinien być STOP")
	assert_eq(reel.roll_duration, 3.0, "Domyślny czas obrotu powinien wynosić 3.0")
	
func test_start_roll_changes_state_to_rollback():
	reel._startRoll(reel.reelID, 5.0)
	assert_eq(reel.state, reel.ROLLBACK, "Po wywołaniu _startRoll() stan powinien być ROLLBACK")

func test_start_roll_sets_correct_reel_positions():
	reel._startRoll(reel.reelID, 5.0)
	assert_eq(reel.reel1.position.y, -1000.0, "Po wywołaniu _startRoll() pozycja reel1 powinna wynosić -1000")
	assert_eq(reel.reel2.position.y, 0.0, "Po wywołaniu _startRoll() pozycja reel2 powinna wynosić 0")

func test_start_roll_sets_roll_duration():
	var duration = 5.0
	reel._startRoll(reel.reelID, duration)
	assert_eq(reel.roll_duration, duration, "Czas trwania obrotu powinien być ustawiony na 5.0")

func test_start_roll_ignores_different_reelID():
	var initial_state = reel.state
	reel._startRoll(reel.reelID + 1, 5.0)  
	assert_eq(reel.state, initial_state, "Stan nie powinien się zmienić, gdy reelID jest inny")
	
func test_move_reels():
	var initial_pos_reel1 = reel.reel1.position.y
	var initial_pos_reel2 = reel.reel2.position.y

	reel._move_reels(10)

	assert_eq(reel.reel1.position.y, initial_pos_reel1 + 10, "Po wywołaniu _move_reels() reel1 powinien zmienić pozycję")
	assert_eq(reel.reel2.position.y, initial_pos_reel2 + 10, "Po wywołaniu _move_reels() reel2 powinien zmienić pozycję")

func test_reel_resets_position():
	reel.reel1.position.y = 1000
	reel.reel2.position.y = 999
	
	reel._move_reels(10)
	
	assert_eq(reel.reel1.position.y, -1000.0, "Po przekroczeniu granicy, reel1 powinien wrócić na -1000")
	assert_eq(reel.reel2.position.y, -1000.0, "Po przekroczeniu granicy, reel2 powinien wrócić na -1000")

func test_move_reels_zero_speed():
	var initial_pos_reel1 = reel.reel1.position.y
	var initial_pos_reel2 = reel.reel2.position.y
	
	reel._move_reels(0)
	
	assert_eq(reel.reel1.position.y, initial_pos_reel1, "Po wywołaniu _move_reels() z prędkością 0, reel1 nie powinien zmienić pozycji")
	assert_eq(reel.reel2.position.y, initial_pos_reel2, "Po wywołaniu _move_reels() z prędkością 0, reel2 nie powinien zmienić pozycji")
	
func test_stop_roll_sets_z_index_correctly() -> void:
	reel.reel1.position.y = -1001
	reel.reel2.position.y = 0

	await reel._stopRoll()

	assert_eq(reel.reel1.z_index, 1, "Top reel (reel1) powinien mieć z_index 1")
	assert_eq(reel.reel2.z_index, 0, "Bottom reel (reel2) powinien mieć z_index 0")

func test_stop_roll_position_offset() -> void:
	reel.reel1.position.y = -1001
	reel.reel2.position.y = 0
	
	await reel._stopRoll()
	
	var top_y = reel.reel1.position.y if reel.reel1.z_index == 1 else reel.reel2.position.y
	var bottom_y = reel.reel2.position.y if reel.reel1.z_index == 1 else reel.reel1.position.y
	
	assert_almost_eq(bottom_y - top_y, 1000.0, 0.1, "Dolny bęben powinien być dokładnie 1000px niżej niż górny")

func test_start_roll_resets_roll_back_duration():
	reel.roll_back_duration = 0.0
	reel._startRoll(reel.reelID, 4.0)
	assert_eq(reel.roll_back_duration, 0.25, "roll_back_duration powinien być resetowany do 0.25")

func test_process_changes_state_to_roll_and_then_stop():
	reel._startRoll(reel.reelID, 0.1) 
	await get_tree().process_frame

	await get_tree().create_timer(0.5).timeout 

	assert_eq(reel.state, reel.STOP, "Po zakończeniu roll_duration stan powinien być STOP")



func test_scroll_reel_wraps_properly():
	reel.reel1.position.y = 1001
	reel._scroll_reel(reel.reel1, 0)  
	assert_eq(reel.reel1.position.y, -1000.0, "Pozycja y powinna zostać zawinięta do -1000")
	
	
# ---------------------
# TESTY INTEGRACYJNE
# ---------------------

func _on_roll_finished(id: int, rng: int) -> void:
	signal_emitted = true
	emitted_reelID = id
	emitted_rng = rng
	
func test_full_reel_cycle_emits_signal():
	SigBank.rollFinished.connect(_on_roll_finished)

	reel._startRoll(reel.reelID, 0.1)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout 

	await get_tree().create_timer(2.0).timeout  

	assert_true(signal_emitted, "Sygnał rollFinished powinien zostać wyemitowany po zakończeniu cyklu")
	assert_eq(emitted_reelID, reel.reelID, "reelID w sygnale powinien być zgodny")
	assert_true(emitted_rng >= 0 and emitted_rng <= 9, "Wartość RNG powinna być w zakresie 0-9")



func test_full_cycle_resets_reel_positions_properly():
	reel._startRoll(reel.reelID, 0.2)
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	
	var top_reel: Sprite2D = reel.reel1 if reel.reel1.z_index == 1 else reel.reel2
	var bottom_reel: Sprite2D = reel.reel2 if reel.reel1.z_index == 1 else reel.reel1
	
	assert_almost_eq(bottom_reel.position.y - top_reel.position.y, 1000.0, 0.1, "Po zakończeniu tweena, odległość między bębnami powinna wynosić 1000px")


func test_multiple_start_roll_calls_only_responds_to_correct_id():
	var second_reel: Node2D = reel_scene.instantiate()
	add_child(second_reel)
	second_reel.reelID = reel.reelID + 1
	await get_tree().process_frame

	var signal_triggered: bool = false
	SigBank.rollFinished.connect(func(id: int, rng: int) -> void: signal_triggered = true)

	second_reel._startRoll(reel.reelID + 100, 0.2)
	await get_tree().create_timer(0.5).timeout
	
	assert_false(signal_triggered, "Bęben nie powinien reagować na startRoll z nieprawidłowym reelID")

	remove_child(second_reel)
	second_reel.queue_free()


func test_pressing_ui_accept_triggers_roll():
	Input.action_press("ui_accept")
	await get_tree().process_frame
	Input.action_release("ui_accept")
	reel.roll_duration = 0.1
	reel.roll_back_duration = 0.05
	var total_time := 0.0
	while reel.state != reel.STOP and total_time < 3.0:
		reel._process(0.05)
		await get_tree().process_frame
		total_time += 0.05

	assert_eq(reel.state, reel.STOP, "Po naciśnięciu ui_accept cykl powinien się zakończyć i stan powinien być STOP")
