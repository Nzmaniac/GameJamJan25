extends Node2D

const CHUNK_SIZE = Vector2(512, 512)
const VIEW_DISTANCE = 2  # How many chunks around the player to load

var active_chunks = {}

onready var player = $Player
onready var chunks_node = $Chunks

func _process(delta):
	var player_pos = player.global_position
	var current_chunk = Vector2(
		floor(player_pos.x / CHUNK_SIZE.x),
		floor(player_pos.y / CHUNK_SIZE.y)
	)

	# Load chunks around the player
	for x in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
		for y in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
			var chunk_pos = current_chunk + Vector2(x, y)
			if not active_chunks.has(chunk_pos):
				load_chunk(chunk_pos)

	# Unload far-away chunks
	for chunk_pos in active_chunks.keys():
		if chunk_pos.distance_to(current_chunk) > VIEW_DISTANCE:
			unload_chunk(chunk_pos)

func load_chunk(chunk_pos):
	var chunk_scene = "res://Chunks/Chunk_%d_%d.tscn" % [chunk_pos.x, chunk_pos.y]
	if not FileAccess.file_exists(chunk_scene):
		print("Chunk %s does not exist" % chunk_scene)
		return

	var chunk = preload(chunk_scene).instance()
	chunk.position = chunk_pos * CHUNK_SIZE
	chunks_node.add_child(chunk)
	active_chunks[chunk_pos] = chunk

func unload_chunk(chunk_pos):
	if active_chunks.has(chunk_pos):
		active_chunks[chunk_pos].queue_free()
		active_chunks.erase(chunk_pos)
