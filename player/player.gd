extends KinematicBody2D

export var speed = 20000

var motion = Vector2.ZERO

func _physics_process(delta):
	motion = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		motion.x += 10
	if Input.is_action_pressed("ui_left"):
		motion.x -= 10
	if Input.is_action_pressed("ui_down"):
		motion.y += 10
	if Input.is_action_pressed("ui_up"):
		motion.y -= 10
	
	motion = motion.normalized() * speed * delta
	move_and_slide(motion)
func _ready():
	pass
