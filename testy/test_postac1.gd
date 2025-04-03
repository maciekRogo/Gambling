extends GutTest

const CharacterBody = preload("res://Scripts/postac_1.gd")

var character

func before_each():
	character = CharacterBody.new()
	add_child(character)

func after_each():
	character.queue_free()

func test_postać_nie_rusza_się_domyslnie():
	assert_eq(character.velocity, Vector2.ZERO, "Postać powinna być nieruchoma na starcie.")

func test_ruch_w_prawo():
	Input.action_press("move_right")
	character.get_input()
	assert_eq(character.velocity, Vector2(character.speed, 0), "Postać powinna się poruszać w prawo.")
	Input.action_release("move_right")

func test_ruch_w_górę():
	Input.action_press("move_up")
	character.get_input()
	assert_eq(character.velocity, Vector2(0, -character.speed), "Postać powinna się poruszać w górę.")
	Input.action_release("move_up")
	
func test_ruch_w_lewo():
	Input.action_press("move_left")
	character.get_input()
	assert_eq(character.velocity, Vector2(-character.speed, 0), "Postać powinna się poruszać w lewo.")
	Input.action_release("move_left")

func test_ruch_w_dół():
	Input.action_press("move_down")
	character.get_input()
	assert_eq(character.velocity, Vector2(0, character.speed), "Postać powinna się poruszać w dół.")
	Input.action_release("move_down")
