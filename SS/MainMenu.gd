extends ColorRect

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AdMob.load_banner()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$AdMob.hide_banner()
	hide()
	emit_signal("start_game")


func _on_Quit_pressed():
	get_tree().quit()
