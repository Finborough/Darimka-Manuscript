extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var speed = 1300  # speed in pixels/sec

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if direction.x < 0 and direction.y == 0:
		sprite.play("walk_e")
		sprite.flip_h = true

	elif direction.x > 0 and direction.y == 0:
		sprite.play("walk_e")
		sprite.flip_h = false

	elif direction.y < 0 and direction.x == 0:
		sprite.play("walk_n")

	elif direction.y > 0 and direction.x == 0:
		sprite.play("walk_s")

	elif direction.y > 0 and direction.x != 0:
		sprite.play("walk_se")
		if direction.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	elif direction.y < 0 and direction.x != 0:
		sprite.play("walk_ne")
		if direction.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	if direction.x == 0 and direction.y == 0:
		sprite.stop()
		sprite.frame = 3
	
	move_and_slide()
