extends ItemList

var hoeImg = load("res://Assets/HotbarAssets/hoe.png")
var barrelImg = load("res://Assets/16 Bit RPG Asset Pack/Barrel (Small).png")
var candleImg = load("res://Assets/16 Bit RPG Asset Pack/Candle (Lit) 1.png")
var cornSeedImg = load("res://Assets/Seeds/CornSeeds.png")

signal item_changed(item_name)

var currentItem = -1
var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	

func change_item(itemName):
	deselect_all()
	for i in item_count:
		if get_item_text(i) == itemName:
			select(i, true)
			item_changed.emit(itemName)


func item_get(itemName):
	var texture
	match itemName:
		"Hoe":
			texture = hoeImg
		"Barrel":
			texture = barrelImg
		"Candle":
			texture = candleImg
		"CornSeeds":
			texture = cornSeedImg
	
	add_item(itemName, texture, true)
	


func _input(event):
	if currentItem > -1:
		if Input.is_action_just_pressed("ScrollDown"):
			currentItem += 1
			if currentItem >= items.size() * 3:
				currentItem = 0
			change_item(items[currentItem/3])
		if Input.is_action_just_pressed("ScrollUp"):
			currentItem -= 1
			if currentItem < 0:
				currentItem = items.size() * 3 - 3
			change_item(items[currentItem/3])

func _on_snaggable_grabbed(itemName):
	print(itemName)
	if currentItem == -1:
		currentItem = 0
	items.append(itemName)
	item_get(itemName)


func _on_item_selected(index):
	currentItem = index * 3


func _on_item_clicked(index, at_position, mouse_button_index):
	change_item(items[index])
