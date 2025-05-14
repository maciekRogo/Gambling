extends CanvasLayer

@onready var money_label = $MoneyLabel

func _process(_delta):
	money_label.text = "Money: " + str(SigBank.money)
