extends Control

func _process(delta):
  if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_right"):
    get_tree().change_scene("res://LevelSelect.tscn")

