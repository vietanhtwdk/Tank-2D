extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseMenu.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Level.text = str(get_node("/root/Main").levelNum)
	$Life.text = str(get_node("/root/Main").playerLife)
	$EnemyLeft.text = str(get_node("/root/Main").enemyLeft)
	$Score.text = str(get_node("/root/Main").score)


func _on_Button_pressed():
	get_tree().paused = true
	$PauseMenu.show()
	
