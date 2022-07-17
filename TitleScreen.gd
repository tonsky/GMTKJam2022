extends Control

func _process(delta):
  if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_cancel"):
    get_tree().change_scene("res://LevelSelect.tscn")

