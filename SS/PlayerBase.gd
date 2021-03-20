extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_frame(0)
	health = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func hit(damage):
	health-=damage
	if health == 1:
		$AnimatedSprite.set_frame(1)
	elif health <= 0:
		queue_free()
		get_node("/root/Main").game_over()
