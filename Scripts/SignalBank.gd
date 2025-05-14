extends Node

var money: int = 1000
var is_roaming = true
var is_chatting = false

signal startRoll(slotID,duration)
signal rollFinished(slotID,result)
