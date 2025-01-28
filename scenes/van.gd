extends CharacterBody2D

var speed = 200
var map_bounds = Rect2(Vector2(0, 0), Vector2(1920, 1080)) 
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

# Predefined sizes for the collision shape
var horizontal_shape_size = Vector2(100, 60)  # Width x Height when horizontal
var vertical_shape_size = Vector2(60, 100)
var horizontal_offset = Vector2(0, 20)  # Offset when horizontal
var vertical_offset = Vector2(0, 0)  # Offset when vertical (move up)    # Width x Height when vertical

func smooth_resize(target_size, target_offset):
	# Smoothly interpolate the collision shape's size toward the target size
	var current_size = collision_shape.shape.extents * 2
	var new_size = current_size.lerp(target_size, 0.1)  # Lerp between current and target size
	collision_shape.shape.extents = new_size / 2  # Convert to extents (half-size)

	# Smoothly interpolate the collision shape's position
	collision_shape.position = collision_shape.position.lerp(target_offset, 0.1)  # Adjust position
	

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed

	# Update animation based on movement direction
	if input_dir.length() > 0:
		if input_dir.x > 0 and input_dir.y < 0:
			sprite.play("north_east")
		elif input_dir.x > 0 and input_dir.y > 0:
			sprite.play("south_east")
		elif input_dir.x < 0 and input_dir.y < 0:
			sprite.play("north_west")
		elif input_dir.x < 0 and input_dir.y > 0:
			sprite.play("south_west")
		elif input_dir.y < 0:
			sprite.play("north")
		elif input_dir.y > 0:
			sprite.play("south")
		elif input_dir.x > 0:
			sprite.play("east")
		elif input_dir.x < 0:
			sprite.play("west")
			
	# Update collision shape size and position based on direction
	if input_dir.y != 0:  # Moving vertically
		smooth_resize(vertical_shape_size, vertical_offset)
	elif input_dir.x != 0:  # Moving horizontally
		smooth_resize(horizontal_shape_size, horizontal_offset)

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	 # Clamp the position within the map boundaries
	global_position.x = clamp(global_position.x, map_bounds.position.x, map_bounds.position.x + map_bounds.size.x)
	global_position.y = clamp(global_position.y, map_bounds.position.y, map_bounds.position.y + map_bounds.size.y)
