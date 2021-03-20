extends KinematicBody2D

var speed = 500
var velocity = Vector2()
var damage
var shooter

func start(pos, dir):
#	print(get_collision_exceptions()[0].name)
	rotation = dir
	position = pos
	velocity = Vector2(0, -speed).rotated(dir)
	$AudioStreamPlayer.play()
	shooter = get_collision_exceptions()[0].name
	
#	print(velocity.normalized())

func _physics_process(delta):
	
	var collision = move_and_collide((velocity * delta))
	if collision:
		if collision.collider is TileMap:
			var tile = collision.collider.world_to_map(collision.position + velocity.normalized())
			print(collision.collider.world_to_map(collision.position)+ velocity.normalized())
			if collision.collider.get_cellv(tile) == 0:
				collision.collider.set_cell(tile.x, tile.y, -1)
			elif collision.collider.get_cellv(tile) == -1:
				if velocity.normalized().round().x != 0:
#					tile = collision.collider.world_to_map(collision.position + velocity.normalized() + Vector2(0 , 1))
#					if collision.collider.get_cellv(tile) == 0:
#						collision.collider.set_cell(tile.x, tile.y, -1)
#					else:
						tile = collision.collider.world_to_map(collision.position + velocity.normalized() + Vector2(0 , -1))
						if collision.collider.get_cellv(tile) == 0:
							collision.collider.set_cell(tile.x, tile.y, -1)
				else:
#					tile = collision.collider.world_to_map(collision.position + velocity.normalized() + Vector2(1 , 0))
#					if collision.collider.get_cellv(tile) == 0:
#						collision.collider.set_cell(tile.x, tile.y, -1)
#					else:
						tile = collision.collider.world_to_map(collision.position + velocity.normalized() + Vector2(-1 , 0))
						if collision.collider.get_cellv(tile) == 0:
							collision.collider.set_cell(tile.x, tile.y, -1)
				
		elif "PlayerBase".is_subsequence_of(collision.collider.name):
			if "Enemy".is_subsequence_of(shooter):
				collision.collider.hit(damage)
		elif "Enemy".is_subsequence_of(collision.collider.name) && "Player".is_subsequence_of(shooter):
			collision.collider.hit(damage)
		elif "Player".is_subsequence_of(collision.collider.name) && "Enemy".is_subsequence_of(shooter): 
			collision.collider.hit(damage)
		elif "Bullet".is_subsequence_of(collision.collider.name):
			collision.collider.hit()
		
		var explosion = load("res://SS/Explosion.tscn").instance()
		explosion.position = collision.position
		get_node("/root/Main").currentLevel.add_child(explosion)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func hit():
	queue_free()
