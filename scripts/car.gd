extends CharacterBody2D


@export var steering_angle = 15 
@export var engine_power = 900  
@export var friction = -55 
@export var drag = -0.06 
@export var braking = -450 
@export var max_speed_reverse = 250 
@export var slip_speed = 400  
@export var traction_fast = 2.5
@export var traction_slow = 10 

var burstPicked=false
var Bbullet = preload("res://scenes/bullet_1.tscn")

var wheel_base=65
var acceleration = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	if burstPicked==false:
		$"../UI/weaponPanel/burstGun".hide()
	elif burstPicked==true:
		$"../UI/weaponPanel/burstGun".show()
	acceleration=Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept") and burstPicked==true:
		burstFire()
		burstPicked=false

func get_input():
	var turn = Input.get_axis("ui_left","ui_right")
	steer_direction= turn * deg_to_rad(steering_angle)

	if Input.is_action_pressed("ui_up"):
		acceleration = transform.x * engine_power
	elif Input.is_action_pressed("ui_down"):
		acceleration = transform.x * braking

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length()<50:
		velocity=Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	
	acceleration+= friction_force + drag_force
	
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	var new_heading = rear_wheel.direction_to(front_wheel)

	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)

	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	rotation = new_heading.angle()


func burstFire():
	for n in range(6):
		var bullet1 = Bbullet.instantiate()
		var bullet2 = Bbullet.instantiate()
		bullet1.dir = rotation
		bullet1.pos = $nozzle1.global_position
		bullet1.rota = global_rotation
		bullet2.dir = rotation
		bullet2.pos = $nozzle2.global_position
		bullet2.rota = global_rotation
		get_parent().add_child(bullet1)
		get_parent().add_child(bullet2)
		await get_tree().create_timer(0.2).timeout



func _on_area_2d_body_entered(body):
	if body.name == "burstGun":
		burstPicked=true
		body.queue_free()
