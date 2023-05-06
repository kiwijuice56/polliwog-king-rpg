class_name PartyOrganizer
extends Node2D

export var size: int = 5
export var offset: int = 29

var party: Array

const platform_scene: PackedScene = preload("res://main/lobby/party_organizer/platform/Platform.tscn")

func _ready() -> void:
	initialize()
 
func initialize() -> void:
	for idx in range(size):
		var platform: Platform = platform_scene.instance()
		add_child(platform)
		platform.position.x += offset * idx
		
		party.append(null)
