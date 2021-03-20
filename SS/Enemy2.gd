extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
var bullet = preload("res://SS/Bullet.tscn")
var MainGame 
var rng = RandomNumberGenerator.new()
var move
var damage
var health
var froze
var Player
var PlayerBase
var toPlayerBase

# Called when the node enters the scene tree for the first time.
func _ready():
	move = 0
	damage = 1
	health = 1
	froze = 0
	rng.randomize()
	MainGame = get_node("/root/Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func shoot():

	if $ReloadTime.is_stopped() == true :
		var bulletn = bullet.instance()
		bulletn.damage = damage
		bulletn.add_collision_exception_with(self)
		bulletn.start($AnimatedSprite/Muzzle.global_position, get_rotation())
		MainGame.currentLevel.add_child(bulletn)
		$ReloadTime.start()
	else: 
		pass


func _on_MoveDelay_timeout():
	move = rng.randi_range(0, 9)
	$MoveDelay.start()
	
func hit(damageTaken):
	health -= damageTaken
	if health <= 0:
		MainGame.score += 400
		MainGame.enemyLeft -= 1
		if MainGame.enemyLeft == 0:
			MainGame.level_clear()
		queue_free()
