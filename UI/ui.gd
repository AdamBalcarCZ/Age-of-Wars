extends CanvasLayer
func _process(_delta):
	$Label.text = "Wood: %d\nGold: %d" % [Game.Wood, Game.Gold]
