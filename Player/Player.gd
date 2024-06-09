extends RigidBody3D

@export var thrust: float = 1000.1
@export var torque_thrust_left: float = 100.0
@export var torque_thrust_right: float = -100.0
var label: Label
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_2: GPUParticles3D = $BoosterParticles2
@onready var booster_particles_3: GPUParticles3D = $BoosterParticles3
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

var is_transitioning: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		rocket_audio.stop()
		booster_particles.emitting = false
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0,0.0,torque_thrust_left * delta))
		booster_particles_2.emitting = true
	else:
		booster_particles_2.emitting = false	
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust_right * delta))
		booster_particles_3.emitting = true
	else:
		booster_particles_3.emitting = false
		
func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		print(body.name)
		if "Goal" in body.get_groups():
			complete_level(body.name,body.file_path)
		if "NotGoal" in body.get_groups():
			crash_sequence()
func crash_sequence() -> void:
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
			get_tree().reload_current_scene
		)
	label = $Label
	label.text = str("Perdeu! Reiniciando o jogo...")
	
func complete_level(pname: String ,next_level_file: String) -> void:
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	label = $Label
	label.text = str("Parabens ",pname)
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
			get_tree().change_scene_to_file.bind(next_level_file)
		)
