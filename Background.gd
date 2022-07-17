extends CanvasLayer

onready var dice = get_parent().get_node("Dice")
onready var cam = get_parent().get_node("Cam")
onready var map = get_parent().get_node("Floor")
onready var left_eye = get_node("LeftEye")
onready var right_eye = get_node("RightEye")
onready var left_pupil = get_node("LeftPupil")
onready var right_pupil = get_node("RightPupil")

var center
var size
var factor

func _ready():
  var bounds = map.get_used_rect()
  size = map.map_to_world(bounds.size)
  center = map.map_to_world(bounds.position) + size * 0.5
  factor = max(bounds.size.x / 30 / 0.66, bounds.size.y / 18 / 0.5)

func _process(delta):
  var offset = (dice.position.x - center.x) / size.x
  left_eye.margin_left = 398 + offset * 40
  left_eye.margin_right = left_eye.margin_left + 40
  left_pupil.margin_left = 398 + offset * 50
  left_pupil.margin_right = left_pupil.margin_left + 40
  
  right_eye.margin_left = 507 + offset * 40
  right_eye.margin_right = right_eye.margin_left + 40
  right_pupil.margin_left = 508 + offset * 50
  right_pupil.margin_right = right_pupil.margin_left + 40
