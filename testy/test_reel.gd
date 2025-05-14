extends GutTest

var reel_scene = preload("res://Scene/reel.tscn") 
var reel 

func before_each():

	reel = reel_scene.instantiate()
	add_child(reel)
	
	await get_tree().process_frame  

func after_each():
	remove_child(reel)
	reel.queue_free()

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
