extends Area2D

@onready var player = $".."
var Bbullet = preload("res://scenes/bullet_1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var enemies = get_overlapping_bodies()
	if enemies.size() > 0:
		var target = enemies.front()
		look_at(target.global_position)
	elif enemies.size() == 0:
		global_rotation = player.global_rotation
	


