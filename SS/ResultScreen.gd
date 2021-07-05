extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Main/EnemySpawnTimer").stop()
	get_node("/root/Main/PowerUpSpawnTimer").stop()
	if (int(load_high_score())<get_node("/root/Main").score):
		save_high_score()
		$Label2.text= str("High score: " + str(get_node("/root/Main").score)) 
	else: 
		$Label2.text= str("High score: " + load_high_score()) 
	$AdMob.load_banner()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$AdMob.hide_banner()
	get_node("/root/Main")._on_MainMenu_start_game()
	queue_free()




func _on_Button2_pressed():
	get_tree().reload_current_scene()
	
func save_high_score():
	var file = File.new()
	file.open("user://high_score.txt", File.WRITE)
	file.store_string(str(get_node("/root/Main").score))
	file.close()

func load_high_score():
	var file = File.new()
	file.open("user://high_score.txt", File.READ)
	var content = file.get_as_text()
	file.close()
	return content
