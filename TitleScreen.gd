extends CanvasLayer

func _ready():
  pass

func _process(delta):
  if Input.is_action_just_released("ui_accept"):
    get_tree().change_scene("res://LevelSelect.tscn")

