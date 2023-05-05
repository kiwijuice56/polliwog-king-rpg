class_name Main
extends Node

func _ready() -> void:
	$TurnCycle.player_party = $PlayerParty.get_children()
	$TurnCycle.enemy_party = $EnemyParty.get_children()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$TurnCycle.play_battle()
