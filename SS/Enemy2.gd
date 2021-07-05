extends "res://SS/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var PlayerBase
var toPlayerBase

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 400
	move = 0
	damage = 1
	health = 1
	froze = 0
	scoreReward = 400
	rng.randomize()
	MainGame = get_node("/root/Main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#

func custom_process(delta):
	if froze == 0:
		var velocity = Vector2() 
		
	
		if move>4 && move<10:
			PlayerBase = get_node_or_null("/root/Main/Level/PlayerBase")
			if PlayerBase != null:
				toPlayerBase = Vector2(PlayerBase.position - position)
				velocity += toPlayerBase.normalized().round()
		
		if move == 0:
			shoot()
		if move == 1:
			velocity.x += 1
		if move == 2:
			velocity.x -= 1
		if move == 3:
			velocity.y += 1
		if move == 4:
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
		
		if velocity.x > 0:
			$AnimatedSprite.animation = "Default"
			rotation_degrees = 90
		elif velocity.x < 0:
			$AnimatedSprite.animation = "Default"
			rotation_degrees = -90
		elif velocity.y > 0:
			$AnimatedSprite.animation = "Default"
			rotation_degrees = 180
		elif velocity.y < 0:
			$AnimatedSprite.animation = "Default"
			rotation_degrees = 0
			
		var collision = move_and_collide(velocity*delta)
		if collision:
			move = 0

func _on_MoveDelay_timeout():
	move = rng.randi_range(0, 9)
	$MoveDelay.start()
