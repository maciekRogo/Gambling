extends GutTest

const CharacterBody = preload("res://Scripts/npc.gd")
var character

func before_each():
	character = load("res://Scene/npc.tscn").instantiate()
	add_child(character)

func after_each():
	character.queue_free()

func test_initial_state():
	assert_eq(character.current_state, character.IDLE, "Początkowy stan powinien być IDLE")
	assert_eq(character.position, character.start_pos, "Pozycja początkowa powinna być równa start_pos")
	assert_eq(character.player_in_chat_zone, false, "NPC nie powinien być początkowo w strefie czatu")

func test_move():
	character.current_state = character.MOVE
	var initial_position = character.position
	character._process(1.0)  
	assert_false(character.position == initial_position, "Pozycja powinna się zmienić podczas ruchu")
	
func test_move_with_chat_zone():
	character.player_in_chat_zone = true
	var initial_position = character.position
	character._process(1.0)  
	assert_eq(character.position, initial_position, "Pozycja nie powinna się zmieniać, gdy gracz jest w strefie czatu")
	
func test_dialogue_end_on_chat_zone_exit():
	var player_node = Node2D.new()
	player_node.name = "postac"
	character._on_chat_detection_area_body_entered(player_node)  
	character._on_chat_detection_area_body_exited(player_node)  
	
	assert_eq(SigBank.is_chatting, false, "NPC powinien przestać czatować")
	assert_eq(SigBank.is_roaming, true, "NPC powinien wrócić do wędrówki")

func test_timer_based_state_change():
	var previous_state = character.current_state
	character._on_timer_timeout()

	assert_ne(character.current_state, previous_state, "Stan powinien się zmienić po uruchomieniu timera")
