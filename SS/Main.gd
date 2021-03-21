extends Node

export (PackedScene) var Enemy
export (PackedScene) var Enemy2
export (PackedScene) var Enemy3
export (PackedScene) var Player
export (PackedScene) var PowerUp
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

var levelNum
var currentLevel
var enemyLeft
var enemySpawnLocation
var enemyLabel
var playerLife
var player
var playerPosition
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$BGMPlayer.play()
	randomize()
	rng.randomize()
	$Background.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if enemyLeft == 0:
#		level_clear()

func _on_MainMenu_start_game():
	$BGMPlayer.stop()
	$Background.show()
	playerLife = 3
	score = 0
	levelNum = 0
	add_child(load("res://SS/HUD.tscn").instance())
	load_level(levelNum)


func load_level(var stage):
	var levelScene = load("res://Level/Level"+ str(stage) +".tscn")
	if levelScene:
		enemyLeft = 20
#
#		level_transition("level "+ str(stage))
		
		var levelTransition = load("res://SS/LevelTransition.tscn").instance()
		add_child(levelTransition)
		levelTransition.get_node("ColorRect/Label").text = str("level "+ str(stage))
		levelTransition.get_node("AnimationPlayer").play("New Anim")
		
#		yield( levelTransition.get_node("AnimationPlayer"), "animation_finished" )
		
		currentLevel = levelScene.instance()
		playerPosition = currentLevel.get_node("PlayerPosition").position
		enemySpawnLocation = currentLevel.get_node("EnemyPath/EnemySpawnLocation")
		
		call_deferred("add_child", currentLevel)

		spawn_player()
		
		$PowerUpSpawnTimer.start()
		$EnemySpawnTimer.start()
	else: game_clear()


func spawn_player():
	player = Player.instance()
	currentLevel.add_child(player)
	player.position = playerPosition

func spawn_enemy():
	var enemyType = rng.randi_range(0, 2)
	var enemy
	match enemyType:
		0: 
			enemy = Enemy.instance()
		1: 
			enemy = Enemy2.instance()
		2:
			enemy = Enemy3.instance()

	currentLevel.add_child(enemy)
	enemy.position = enemySpawnLocation.position

func _on_EnemySpawnTimer_timeout():
	if get_tree().get_nodes_in_group("Enemies").size() < 5:
		if enemyLeft > 0 && get_tree().get_nodes_in_group("Enemies").size() < enemyLeft:
			enemySpawnLocation.offset = randi()
			spawn_enemy()
		else: $EnemySpawnTimer.stop()
	
func level_clear():
	$EnemySpawnTimer.stop()
	$PowerUpSpawnTimer.stop()
	currentLevel.queue_free()
	levelNum += 1
	load_level(levelNum)
	
func game_over():
#	var enemies = get_tree().get_nodes_in_group("Enemies")
#	for enemy in enemies:
#		enemy.queue_free()
#	$MainMenu.show()
#	$EnemySpawnTimer.stop()
#	$GameOver.show()
#	var t = Timer.new()
#	t.set_wait_time(3)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	get_tree().reload_current_scene()
	$EnemySpawnTimer.stop()
	$PowerUpSpawnTimer.stop()
	$Result/Label.text = str("Game over")
	$Result/Label.show()
	$Result/ResultTimer.start()



func game_clear():
	$EnemySpawnTimer.stop()
	$PowerUpSpawnTimer.stop()
	$Result/Label.text = str("Game Cleared")
	$Result/Label.show()
	$Result/ResultTimer.start()


func _on_PowerUpSpawnTimer_timeout():
	var powerType = rng.randi_range(0, 5)
	var powerUp = PowerUp.instance()
	powerUp.type = powerType
	powerUp.position = Vector2(rng.randi_range(50, 1100), rng.randi_range(50, 660))
	currentLevel.add_child(powerUp)


func _on_FreezeTimer_timeout():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.froze = 0



func _on_ResultTimer_timeout():
	$Result/Label.hide()
	get_node("HUD").queue_free()
	if currentLevel != null:
		currentLevel.queue_free()
	var resultScreen = load("res://SS/ResultScreen.tscn").instance()
	resultScreen.get_node("Label").text = str("Level Reached: " 
	+ str(levelNum) +  "\nScore: " + str(score))
	add_child(resultScreen)
