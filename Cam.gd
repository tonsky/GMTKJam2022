extends Camera2D

onready var dice = get_parent().get_node("Dice")
onready var map = get_parent().get_node("Floor")
var center
var size
var factor
var shaked = false

func update():
  var delta = (center - dice.position) / max(size.x, size.y)
  var down = 0
  if shaked:
    down = 8 * factor
  position = center - Vector2(delta.x * 32, down) - Vector2(0, 100 * factor)

func _ready():
  var bounds = map.get_used_rect()
  size = map.map_to_world(bounds.size)
  center = map.map_to_world(bounds.position) + size * 0.5
  factor = max(bounds.size.x / 30 * 4 / 0.66, bounds.size.y / 18 * 4 / 0.5)
  smoothing_enabled = false
  zoom = Vector2(factor, factor)
  update()

func _process(_delta):
  if not smoothing_enabled:
    smoothing_enabled = true
  update()  

func _on_Dice_moved():
  shaked = true
  $ShakeTimer.start(0.1)

func _on_ShakeTimer_timeout():
  shaked = false
