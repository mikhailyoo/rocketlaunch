extends RigidBody3D

## Vertical speed of the Rocket
@export_range(500, 3000) var engine_power: float = 1000
@export var rotation_power: float = 100

@onready var audio_victory: AudioStreamPlayer = $AudioVictory


var is_blocked: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * delta * engine_power)
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * rotation_power)
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * rotation_power)


func victory(next_level):
	is_blocked = true
	set_process(false)
	print("Victory")
	audio_victory.play()
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level))
	

func crushed():
	is_blocked = true
	set_process(false)
	print("You Crashed!")
	$AudioExplosion.play()
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().reload_current_scene)


func _on_body_entered(body: Node) -> void:
	if is_blocked == false:
		if "Victory" in body.get_groups():
			call_deferred("victory", body.next_level)
			
		if "Obstacle" in body.get_groups():
			call_deferred("crushed")
