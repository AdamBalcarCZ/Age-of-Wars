extends Label

# --- FEATURE: SMOOTH FLOATING ANIMATION ---
func show_value(value: int) -> void:
	text = "+" + str(value) + " Gold"
	var tw = create_tween().set_parallel(true)
	# Moves up and fades out at the same time
	tw.tween_property(self, "position:y", position.y - 100, 1.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 0.0, 1.4)
	tw.chain().tween_callback(queue_free)
