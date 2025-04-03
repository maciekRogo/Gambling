extends Button
func _ready():
	self.pressed.connect(_on_pressed)
func _on_pressed():
	get_tree().quit()
