extends RigidBody3D

## Vertical speed of the Rocket
@export_range(500, 3000) var engine_power: float = 1000
@export var rotation_power: float = 100

@onready var audio_victory: AudioStreamPlayer = $AudioVictory
@onready var engine_sound: AudioStreamPlayer3D = $EngineSound
@onready var smoke_particles_component: GPUParticles3D = $SmokeParticlesComponent
@onready var smoke_particles_left: GPUParticles3D = $SmokeParticlesLeft
@onready var smoke_particles_right: GPUParticles3D = $SmokeParticlesRight
@onready var explosion_component: GPUParticles3D = $ExplosionComponent


var is_blocked: bool = false

func _process(delta: float) -> void:
	var is_moving: bool = false
	if Input.is_action_pressed("move_up"):
		is_moving = true
		apply_central_force(basis.y * delta * engine_power)
		smoke_particles_component.emitting = true
	else:
		smoke_particles_component.emitting = false
		
	if Input.is_action_pressed("left"):
		is_moving = true
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * rotation_power)
		smoke_particles_left.emitting = true
	else:
		smoke_particles_left.emitting = false
		
	if Input.is_action_pressed("right"):
		is_moving = true
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * rotation_power)
		smoke_particles_right.emitting = true
	else:
		smoke_particles_right.emitting = false
		
	if is_moving:
		if not engine_sound.playing:
			engine_sound.play()
	else:
		engine_sound.stop()


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
	explosion_component.emitting = true
	$AudioExplosion.play()
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().reload_current_scene)


func _on_body_entered(body: Node) -> void:
	if is_blocked == false:
		smoke_particles_component.emitting = false
		smoke_particles_right.emitting = false
		smoke_particles_left.emitting = false
		engine_sound.stop()
		
		if "Victory" in body.get_groups():
			call_deferred("victory", body.next_level)
			
		if "Obstacle" in body.get_groups():
			call_deferred("crushed")
