extends CharacterBody2D


var speed = 150
var accel = 30

var current_item

var player_has_control = true

@onready var tile_map: TileMap = $"../TileMap"
@onready var player: CharacterBody2D = $"."

@onready var animation = get_node("PlayerAnimation")





func _physics_process(_delta):
	if player_has_control:
		#Taken from Horen Star's video on "Smooth and Easy Top Down Movement"
		var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
		if direction.x != 0:
			if (velocity.x > 0 && direction.x < 0) || (velocity.x < 0 && direction.x > 0): # If they change directions
				velocity.x = 0 
			velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		else: # If the player isn't holding a direction, we want them to stop on a dime.
			velocity.x = 0
		if direction.y != 0:
			if (velocity.y > 0 && direction.y < 0) || (velocity.y < 0 && direction.y > 0): # If they change directions
				velocity.y = 0 
			velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		else:
			velocity.y = 0
			
		if velocity.x != 0 || velocity.y != 0:
			animation.play("Walk", speed / 150, false)
		else:
			animation.pause()
		move_and_slide()






func _input(event):
	if player_has_control:
		if Input.is_action_just_pressed("Click"):
			match current_item:
				"Hoe":
					use_hoe()
				"CornSeeds":
					use_corn_seeds()
				_:
					no_item_selected()
		
		


func adjacent(first:Vector2, second:Vector2):
	if first.x == second.x - 1 or first.x == second.x or first.x == second.x + 1:
		if first.y == second.y - 1 or first.y == second.y or first.y == second.y + 1:
			return true
	return false

func use_hoe():
	# This takes the mouse position to the maps local position, then converts it to the tile
	var tile_pos = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
	# This takes the player's position in reference to the map's local position, then tile
	var player_pos = tile_map.local_to_map(tile_map.to_local(player.position))
	if adjacent(tile_pos, player_pos):
		player_has_control = false
		animation.play("HoeGround")
		await get_tree().create_timer(1.0).timeout
		animation.play("Walk")
		tile_map.set_cell(0, tile_pos, 0, Vector2i(0, 0), 0)
		player_has_control = true


func tile_is_plantable(tile: Vector2):
	return tile_map.get_cell_atlas_coords(0, tile, false) == Vector2i(0, 0)


func use_corn_seeds():
	# This takes the mouse position to the maps local position, then converts it to the tile
	var tile_pos = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
	# This takes the player's position in reference to the map's local position, then tile
	var player_pos = tile_map.local_to_map(tile_map.to_local(player.position))
	if tile_is_plantable(tile_pos) and adjacent(tile_pos, player_pos):
		player_has_control = false
		animation.play("ScatterSeeds")
		await get_tree().create_timer(3.0).timeout
		animation.play("Walk")
		tile_map.set_cell(0, tile_pos, 0, Vector2i(1, 0), 0)
		player_has_control = true

func no_item_selected():
	print ("No item selected!")


func _on_item_list_item_changed(item_name):
	current_item = item_name