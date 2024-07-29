extends ItemList

var hoeImg = preload("res://Assets/HotbarAssets/hoe.png")
var barrelImg = preload("res://Assets/16 Bit RPG Asset Pack/Barrel (Small).png")
var candleImg = preload("res://Assets/16 Bit RPG Asset Pack/Candle (Lit) 1.png")
var cornSeedImg = preload("res://Assets/Seeds/CornSeeds.png")

var json_dictionary = {}

signal item_changed(item_name)

var currentItem = -1
var items = []
var itemCount = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var item_json = FileAccess.open("res://item_list.json", FileAccess.READ)
	var json_as_text = item_json.get_as_text()
	json_dictionary = JSON.parse_string(json_as_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	

func change_item(index):
	deselect_all()
	select(index)
	currentItem = index * 3
	var temp = json_dictionary[get_item_text(index).get_slice("(", 0)]
	item_changed.emit(temp)



func item_get(itemID):
	print ("Item get!")
	var texture
	if itemCount.has(itemID):
		itemCount[itemID] += 1
		set_item_text(items.find(itemID), json_dictionary.find_key(itemID) + 
			"(" + str(itemCount[itemID]) + ")")
	else:
		print ("First time")
		itemCount[itemID] = 1
		match itemID:
			1.0:
				texture = hoeImg
			0.0:
				texture = cornSeedImg
			_:
				print ("ITS FAILING")
		add_item(json_dictionary.find_key(itemID), texture, true)

 
func _input(event):
	if currentItem > -1:
		if Input.is_action_just_pressed("ScrollDown"):
			currentItem += 1
			if currentItem >= items.size() * 3:
				currentItem = 0
			change_item(currentItem/3)
		if Input.is_action_just_pressed("ScrollUp"):
			currentItem -= 1
			if currentItem < 0:
				currentItem = items.size() * 3 - 3
			change_item(currentItem/3)


func _on_snaggable_grabbed(itemName):
	if currentItem == -1:
		currentItem = 0 
	var itemID = json_dictionary[itemName]
	if itemID not in items:
		items.append(itemID)
	item_get(itemID)



func _on_item_selected(index):
	currentItem = index * 3


func _on_item_clicked(index, at_position, mouse_button_index):
	change_item(index)
