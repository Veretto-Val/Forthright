extends Node2D

var health = 100
var stage = 0

@onready var tile_map: TileMap = $"../../TileMap"
@onready var timer: Timer = $Timer

var tile_pos

const stage_one = Vector2(2, 0)
const stage_two = Vector2(3, 0)
const fully_grown = Vector2(4, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_pos = tile_map.local_to_map(tile_map.to_local(self.position))

func _on_timer_timeout():
	stage += 1
	match stage:
		1:
			tile_map.set_cell(0, tile_pos, 0, stage_one, 0)
		2:
			tile_map.set_cell(0, tile_pos, 0, stage_two, 0)
		3:
			tile_map.set_cell(0, tile_pos, 0, fully_grown, 0)
			timer.stop()
	
