extends CanvasLayer

onready var btn = load("res://LevelButton.tscn")
onready var selection = get_node("Selection")
onready var core = get_node("/root/Core")
var levels = 12
var width = 4
var height = 3
var tile = 128
var gap = 16
var cooldown = 0.25
var time_left = 0

func to_world(x, y):
  var w = tile * width + gap * (width - 1)
  var h = tile * height + gap * (height - 1)
  return Vector2(512 - w / 2 + (x + 0.5) * tile + x * gap, 332 - h / 2 + (y + 0.5) * tile + y * gap)

func selection_pos():
  var x = (core.level - 1) % width
  var y = int(floor((core.level - 1) / width))
  return to_world(x, y)

func _ready():
  for x in range(0, width):
    for y in range(0, height):
      var level = y * width + x + 1
      if level <= core.max_level:
        var instance = btn.instance()
        instance.position = to_world(x, y)
        var label = instance.find_node("Label")
        label.text = "%s" % level
        if core.finished.get(level, false):
          label.add_color_override("font_color", Color(0,0.3,0,1))
          instance.find_node("Button").animation = "finished"
        add_child(instance)
  selection.position = selection_pos()
  selection.play()
  
func _process(delta):
  if Input.is_action_just_released("ui_cancel"):
    get_tree().change_scene("res://TitleScreen.tscn")    
  elif Input.is_action_just_released("ui_accept"):
    get_tree().change_scene("res://Levels/Level%s.tscn" % core.level)
  else:
    time_left -= delta
    if time_left <= 0:
      if Input.is_action_pressed("ui_right"):
        if core.level < core.max_level:
          core.level += 1
        else:
          core.level = 1
        time_left = cooldown
      elif Input.is_action_pressed("ui_left"):
        if core.level > 1:
          core.level -= 1
        else:
          core.level = core.max_level
        time_left = cooldown
      elif Input.is_action_pressed("ui_down"):
        core.level = min(core.max_level, core.level + width)
        time_left = cooldown
      elif Input.is_action_pressed("ui_up"):
        core.level = max(1, core.level - width)
        time_left = cooldown
      selection.position = selection_pos()
    
