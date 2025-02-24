extends CharacterBody2D


@onready var player = get_parent().get_node("car")
@onready var Sprite= $AnimatedSprite2D

func _physics_process(delta):
	Sprite.play("default")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 7000 * delta
	
	
	Sprite.scale.x = 1 if velocity.x < 0 else -1
	
	move_and_slide()
