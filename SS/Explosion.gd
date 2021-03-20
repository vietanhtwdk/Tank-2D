extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if is_playing()==false:
#		queue_free()


func _on_Explosion_animation_finished():
	queue_free()
