class_name TurnCycle
extends Node

var enemy_party: Array
var player_party: Array
var action_queue: Array

signal event_triggered(event, data)

func play_battle() -> void:
	# Initialize trigger signals
	for fighter in enemy_party + player_party:
		fighter.turn_cycle = self
		for action in fighter.get_node("Actions").get_children():
			connect("event_triggered", action, "_on_event_triggered")
			action.turn_cycle = self
	
	emit_signal("event_triggered", Event.BATTLE_STARTED, {})
	
	# Combat is split into two phases:
	# Pre- and Post- attack
	# Most abilities can be prompted in either phase (such as triggers based on damage), but the 
	# phases act as catalysts for starting large chain reactions. In between both phases, the two
	# front fighters will attack each other in a special action. 
	while not (enemy_party.empty() or player_party.empty()):
		print(player_party, " ", enemy_party)
		
		emit_signal("event_triggered", Event.PREATTACK, {})
		if not action_queue.empty():
			yield(play_all_actions(), "completed") # Pre-attack phase
		update_parties()
		
		if enemy_party.empty() or player_party.empty():
			break
		player_party[0].take_damage(enemy_party[0].deal_damage(player_party[0]), enemy_party[0])
		enemy_party[0].take_damage(player_party[0].deal_damage(enemy_party[0]), player_party[0])
		update_parties()
		print("~attack~ ", player_party, " ", enemy_party)
		
		emit_signal("event_triggered", Event.POSTATTACK, {})
		if not action_queue.empty():
			yield(play_all_actions(), "completed") # Post-attack phase
		update_parties()

func play_all_actions() -> void:
	while not action_queue.empty():
		# It would be better to use a min heap, but the performance boost for small arrays does not
		# outweigh the hassle of implementing a custom priority queue
		action_queue.sort_custom(Action, "_compare")
		var action_call: ActionCall = action_queue.pop_front()
		yield(action_call.action.play(action_call.params), "completed")
	update_parties()

func update_parties() -> void:
	for party in [player_party, enemy_party]:
		for idx in range(len(party)):
			if party[idx].hp <= 0:
				party.pop_at(idx)
				idx -= 1
