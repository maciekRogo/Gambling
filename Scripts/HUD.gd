extends CanvasLayer

@onready var money_label = $MoneyLabel

func _process(_delta):
	money_label.text = "Money: " + str(SigBank.money)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		SigBank.money += 1000
