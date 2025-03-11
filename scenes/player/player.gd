extends Node3D


var growing_number: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var number: int = 250
	number += 5
	print(number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("spacebar pressed")
		growing_number += 5.3
		print(growing_number)
