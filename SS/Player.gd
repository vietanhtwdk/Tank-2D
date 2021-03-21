extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300
var screen_size 
var bullet = preload("res://SS/Bullet.tscn")
var MainGame 
var damage
var health
var shield

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 1
	damage = 1
	screen_size = get_viewport_rect().size
	MainGame = get_node("/root/Main")

func start(pos):
	position = pos
	show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
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
		
	move_and_collide(velocity*delta)
	
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
	if shield == 1:
		$Shield.play()
		$Shield.show()

func _physics_process(delta):
	for child in $Ray.get_children():
		var collider = child.get_collider()
		if collider!= null:
			if collider.is_in_group("Enemies") && collider.froze==0:
				collider.shoot()

func shoot():
	if $ReloadTime.is_stopped() == true :
		var bulletn = bullet.instance()
		bulletn.damage = damage
		bulletn.scale = Vector2(1+0.125*(damage-1),1+0.125*(damage-1))
		bulletn.add_collision_exception_with(self)
		bulletn.start($AnimatedSprite/Muzzle.global_position, get_rotation())
		MainGame.currentLevel.add_child(bulletn)
		$ReloadTime.start()
	else: 
		pass

func hit(damageTaken):
	if shield == 1:
		shield = 0
		$Shield.hide()
	else:
		health -= damageTaken
		if health <= 0:
			queue_free()
			var playerLife = MainGame.playerLife
			if playerLife > 0 :
				MainGame.playerLife -= 1
				MainGame.spawn_player()
			else: MainGame.game_over()
