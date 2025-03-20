extends RigidBody3D

## Vertical speed of the Rocket
@export_range(500, 3000) var engine_power: float = 1000
@export var rotation_power: float = 100


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * delta * engine_power)
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * rotation_power)
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * rotation_power)


func victory(next_level):
	print("Victory")
	get_tree().change_scene_to_file(next_level)
	

func crushed():
	print("You Crashed!")
	get_tree().reload_current_scene()


func _on_body_entered(body: Node) -> void:
	if "Victory" in body.get_groups():
		call_deferred("victory", body.next_level)
		
	if "Obstacle" in body.get_groups():
		call_deferred("crushed")
