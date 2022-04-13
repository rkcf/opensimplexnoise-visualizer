extends KinematicBody2D

export (int) var speed = 150

var velocity: Vector2 = Vector2()
var zoom_level: Vector2 = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	move()
	if Input.is_action_just_released("ui_page_up"):
		$Camera2D.zoom.x -= .1
		$Camera2D.zoom.y -= .1
	if Input.is_action_just_released("ui_page_down"):
		$Camera2D.zoom.x += .1
		$Camera2D.zoom.y += .1
	


func move() -> void:
	velocity = get_input()
	velocity = move_and_slide(velocity)


func get_input() -> Vector2:
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	velocity = velocity.normalized() * speed
	return velocity
