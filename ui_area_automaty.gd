
extends Area2D

@onready var prompt_label = $"/root/TileMap/Press_E_to_play"
var player_inside = false



func _on_body_entered(body):
	print("Funkcja _on_body_entered wywołana")
	print("Something entered:", body.name)  
	
	if body.name == "postac":  
		print("Player entered the area!")
		prompt_label.visible = true 
		player_inside = true  


func _on_body_exited(body):
	print("Something exited:", body.name)  

	if body.name == "postac":
		print("Player left the area!")
		prompt_label.visible = false  
		player_inside = false  
		
func _process(delta):
	if player_inside and Input.is_action_just_pressed("ui_click"):  
		get_tree().change_scene_to_file("res://automaty_gra.tscn")  
		print("player_inside:", player_inside)


		
