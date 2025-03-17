extends RigidBody3D


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * delta * 1000)
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * 100)
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * 100)


func _on_body_entered(body: Node) -> void:
	if "Victory" in body.get_groups():
		print("Victory")
		
	if "Obstacle" in body.get_groups():
		print("You Crashed!")
