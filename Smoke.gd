extends AnimatedSprite

func _on_animation_finished():
  queue_free()
