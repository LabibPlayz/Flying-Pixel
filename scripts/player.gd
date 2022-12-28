extends KinematicBody2D


const UP = Vector2(0, -1)
const FLAP = 200
const MAXFALLSPEED = 200
const GRAVITY = 10

var motion = Vector2()
var Wall = preload("res://wallNode.tscn")
var score = 0

onready var wingFlap = $WingFlap

func _ready():
	pass

func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y =MAXFALLSPEED
	if Input.is_action_just_pressed("FLAP"):
		motion.y = -FLAP
		
	motion = move_and_slide(motion, UP)
	
	get_parent().get_parent().get_node("playerNode/pointCounter").text = str(score)

func Wall_reset():
	var Wall_instance = Wall.instance()
	Wall_instance.position = Vector2(450, rand_range(-60, 60))
	get_parent().call_deferred("add_child", Wall_instance)
	
func _on_resetter_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
		Wall_reset()


func _on_detect_area_entered(area):
	if area.name == "pointArea":
		score = score + 1
		$pointGot.play()
	if area.name == "deathUp" or area.name == "deathDown":
		get_tree().change_scene("res://GameOverScreen.tscn")

func _on_detect_body_entered(body):
	if body.name == "Walls":
		get_tree().change_scene("res://GameOverScreen.tscn")


func _process(delta):
	if Input.is_action_just_pressed("FLAP"):
		wingFlap.play()
