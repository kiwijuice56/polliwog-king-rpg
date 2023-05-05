class_name Counter
extends Action

func is_triggered(event: int, params: Dictionary) -> bool:
	return event == Event.DAMAGE_TAKEN and params.defender == action_owner

func play(params: Dictionary) -> void:
	var counter_hitter: Node = params.defender
	var counter_target: Node = params.attacker
	
	if counter_target.hp > 0:
		counter_hitter.deal_damage(counter_target)
		counter_target.take_damage(1, counter_hitter)
		print(self, " ", counter_hitter, " ", counter_target)
	
	call_deferred("emit_signal", "action_completed")
	yield(self, "action_completed")
