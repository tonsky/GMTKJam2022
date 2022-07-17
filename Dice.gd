extends AnimatedSprite

var dice
var dice_left
var dice_right
var dice_up
var dice_down
var dice_opposite
var speed
var start_pos
var cooldown = 0.24
var time_left
onready var map = get_parent().get_node("Floor")
onready var tileset = map.tile_set
onready var smoke = load("res://Smoke.tscn")
onready var progress = get_parent().find_node("Progress")
onready var stats = get_parent().find_node("Stats")
onready var core = get_node("/root/Core")
var congrats
var goal = 0
var score = 0

func update_hud():
  progress.text = "Progress %s/%s" % [score, goal]
  if score >= goal:
    core.finished[core.level] = true
    stats.visible = false
    congrats = load("res://Congrats.tscn").instance()
    get_parent().add_child(congrats)

func init():
  stop()
  animation = "faces"
  frame = 0
  dice = 1
  dice_left = 2
  dice_right = 5
  dice_up = 3
  dice_down = 4
  dice_opposite = 6
  speed = Vector2.ZERO  
  time_left = 0
  position = start_pos
  score = 0
  stats.visible = true
  if congrats:
    get_parent().remove_child(congrats)
    congrats.queue_free()
    congrats = null
  update_hud()

func _ready():
  for name in ["one", "two", "three", "four", "five", "six"]:
    var id = tileset.find_tile_by_name(name)
    goal += len(map.get_used_cells_by_id(id))
  start_pos = position
  init()

func _process(delta):
  if time_left > 0:
    time_left -= delta
    return
  
  if Input.is_action_just_released("restart_level"):
    for name in ["one", "two", "three", "four", "five", "six"]:
      var full_id = tileset.find_tile_by_name(name + "_full")
      var id = tileset.find_tile_by_name(name)
      for cell in map.get_used_cells_by_id(full_id):
        map.set_cellv(cell, id)
    init()
    
  elif Input.is_action_just_released("ui_cancel"):
    get_tree().change_scene("res://LevelSelect.tscn")
    
  elif score >= goal and core.level == core.max_level and Input.is_action_just_released("ui_accept"):
    get_tree().change_scene("res://LevelSelect.tscn")
    
  elif score >= goal and core.level < core.max_level and Input.is_action_just_released("ui_accept"):
    core.level += 1
    get_tree().change_scene("res://Levels/Level%s.tscn" % core.level)
    
  elif score < goal and not playing:
    if Input.is_action_pressed("move_right"):
      speed.x = 32
    elif Input.is_action_pressed("move_left"):
      speed.x = -32
    elif Input.is_action_pressed("move_down"):
      speed.y = 32
    elif Input.is_action_pressed("move_up"):
      speed.y = -32
    else:
      speed = Vector2.ZERO
      
    if speed != Vector2.ZERO:
      var next_pos = position + speed
      var map_pos = map.world_to_map(next_pos)
      var cell = map.get_cellv(map_pos)
      if cell != TileMap.INVALID_CELL:
        
        if speed.x > 0: # move_right
          var old_dice = dice
          dice = dice_left
          dice_left = dice_opposite
          dice_opposite = dice_right
          dice_right = old_dice
          animation = "roll_right"
        elif speed.x < 0: # move_left
          var old_dice = dice
          dice = dice_right
          dice_right = dice_opposite
          dice_opposite = dice_left
          dice_left = old_dice
          animation = "roll_left"          
        elif speed.y > 0: # move_down
          var old_dice = dice
          dice = dice_up
          dice_up = dice_opposite
          dice_opposite = dice_down
          dice_down = old_dice
          animation = "roll_down"
        elif speed.y < 0: # move_up
          var old_dice = dice
          dice = dice_down
          dice_down = dice_opposite
          dice_opposite = dice_up
          dice_up = old_dice
          animation = "roll_up"
      
        var s = smoke.instance()
        get_parent().add_child(s)
        s.position = position
        s.visible = true
        s.frame = 0
        s.play()
        
        position += speed * 0.5
        frame = 0
        play()

func _on_animation_finished():
  stop()
  animation = "faces"
  frame = dice - 1
  position += speed * 0.5
  speed = Vector2.ZERO
  time_left = cooldown
  
  var map_pos = map.world_to_map(position)
  var cell = map.get_cellv(map_pos)    
  var cell_name = tileset.tile_get_name(cell)
  if dice == 1 and cell_name == "one":
    map.set_cellv(map_pos, tileset.find_tile_by_name('one_full'))
    score += 1
    update_hud()
  elif dice == 2 and cell_name == "two":
    map.set_cellv(map_pos, tileset.find_tile_by_name('two_full'))
    score += 1
    update_hud()
  elif dice == 3 and cell_name == "three":
    map.set_cellv(map_pos, tileset.find_tile_by_name('three_full'))
    score += 1
    update_hud()
  elif dice == 4 and cell_name == "four":
    map.set_cellv(map_pos, tileset.find_tile_by_name('four_full'))
    score += 1
    update_hud()
  elif dice == 5 and cell_name == "five":
    map.set_cellv(map_pos, tileset.find_tile_by_name('five_full'))
    score += 1
    update_hud()
  elif dice == 6 and cell_name == "six":
    map.set_cellv(map_pos, tileset.find_tile_by_name('six_full'))
    score += 1
    update_hud()
