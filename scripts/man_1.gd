extends CharacterBody2D

var speed = 200
var map_bounds = Rect2(Vector2(0, 0), Vector2(1920, 1080))  # Define the map boundaries

@onready var animated_sprite = $AnimatedSprite2D 
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	if input_dir.length() > 0:
		if input_dir.x > 0:  # Moving right
			animated_sprite.flip_h = false
			animated_sprite.play("walk-profile")
		elif input_dir.x < 0:  # Moving left
			animated_sprite.flip_h = true
			animated_sprite.play("walk-profile")
		elif input_dir.y > 0:  # Moving down
			animated_sprite.play("walk-front")
		elif input_dir.y < 0:  # Moving up
			animated_sprite.play("walk-back")
	else:
		animated_sprite.play("idle-front")  # Replace with your idle animation name
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	 # Clamp the position within the map boundaries
	global_position.x = clamp(global_position.x, map_bounds.position.x, map_bounds.position.x + map_bounds.size.x)
	global_position.y = clamp(global_position.y, map_bounds.position.y, map_bounds.position.y + map_bounds.size.y)
	
