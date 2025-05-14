extends GutTest

const CharacterBody = preload("res://Scripts/postac_1.gd")

var character

func before_each():
	character = load("res://Scene/postac1.tscn").instantiate()
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
func test_ruch_po_skosie_prawo_dół():
	Input.action_press("move_right")
	Input.action_press("move_down")
	character.get_input()
	var expected = Vector2(1, 1).normalized() * character.speed
	assert_almost_eq(character.velocity.x, expected.x, 0.01, "X velocity niepoprawna dla ruchu po skosie w prawo-dół")
	assert_almost_eq(character.velocity.y, expected.y, 0.01, "Y velocity niepoprawna dla ruchu po skosie w prawo-dół")
	Input.action_release("move_right")
	Input.action_release("move_down")


func test_ruch_po_skosie_lewo_góra():
	Input.action_press("move_left")
	Input.action_press("move_up")
	character.get_input()  
	var expected_velocity = Vector2(-1, -1).normalized() * character.speed
	assert_almost_eq(character.velocity.x, expected_velocity.x, 0.01, "X velocity niepoprawna dla ruchu po skosie w lewo-górę")
	assert_almost_eq(character.velocity.y, expected_velocity.y, 0.01, "Y velocity niepoprawna dla ruchu po skosie w lewo-górę")
	Input.action_release("move_left")
	Input.action_release("move_up")



func test_zatrzymanie_animacji():
	character.direction = Vector2(0, 0)
	character.anim_sprite.animation = "walk_down"
	character.update_animation()
	assert_eq(character.anim_sprite.animation, "idle_down", "Animacja powinna przejść na idle_down po zatrzymaniu.")

func test_animacja_walk_right():
	character.direction = Vector2(1, 0)
	character.update_animation()
	assert_eq(character.anim_sprite.animation, "walk_right", "Animacja powinna być walk_right.")

func test_animacja_walk_left():
	character.direction = Vector2(-1, 0)
	character.update_animation()
	assert_eq(character.anim_sprite.animation, "walk_left", "Animacja powinna być walk_left.")

func test_animacja_walk_up():
	character.direction = Vector2(0, -1)
	character.update_animation()
	assert_eq(character.anim_sprite.animation, "walk_up", "Animacja powinna być walk_up.")

func test_animacja_walk_down():
	character.direction = Vector2(0, 1)
	character.update_animation()
	assert_eq(character.anim_sprite.animation, "walk_down", "Animacja powinna być walk_down.")
