extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var type
var MainGame

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_frame(type)
	MainGame = get_node("/root/Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PowerUp_body_entered(body):
	if "Player".is_subsequence_of(body.name) && "PlayerBase".is_subsequence_of(body.name)==false:
		match type:
			0:	
				MainGame.playerLife += 1
			1:
				if body.damage <=4:
					body.damage += 1
			2:
				body.shield = 1
			3:
				var enemies = get_tree().get_nodes_in_group("Enemies")
				for enemy in enemies:
					enemy.hit(10)
			4:
				var enemies = get_tree().get_nodes_in_group("Enemies")
				for enemy in enemies:
					enemy.speed = 1
			5:
				MainGame.get_node("FreezeTimer").start()
				var enemies = get_tree().get_nodes_in_group("Enemies")
				for enemy in enemies:
					enemy.froze = 1
		queue_free()


func _on_ExsistTimer_timeout():
	queue_free()
