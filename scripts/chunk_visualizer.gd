extends Node2D

const CHUNK_SIZE = Vector2(512, 512)  # Adjust as needed
const WORLD_BOUNDS = Rect2(Vector2(-2048, -2048), Vector2(4096, 4096))  # Define the world size

func _draw():
	for x in range(int(WORLD_BOUNDS.position.x / CHUNK_SIZE.x), int(WORLD_BOUNDS.end.x / CHUNK_SIZE.x)):
		for y in range(int(WORLD_BOUNDS.position.y / CHUNK_SIZE.y), int(WORLD_BOUNDS.end.y / CHUNK_SIZE.y)):
			var chunk_rect = Rect2(Vector2(x, y) * CHUNK_SIZE, CHUNK_SIZE)
			draw_rect(chunk_rect, Color(0, 1, 0, 0.3), false)  # Green borders for visualization

func _process(delta):
	queue_redraw()
