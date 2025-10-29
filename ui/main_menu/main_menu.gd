extends Control

const PORT : int = 3000

var main_scene : PackedScene = preload("uid://bo2vd0hxpu344")

@onready var host_button : Button =$HBoxContainer/HostButton
@onready var join_button : Button = $HBoxContainer/JoinButton

func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func get_local_ip() -> String:
	var ip = ""
	for address in IP.get_local_addresses():
		if "." in address and not address.begins_with("127.") and not address.begins_with("169.254."):
			if address.begins_with("192.168.") or address.begins_with("10.") or \
				(address.begins_with("172.") and int(address.split(".")[1]) >= 16 and int(address.split(".")[1]) <= 31):
				ip = address
				break
	print(ip)
	return ip

func _on_host_pressed() -> void:
	var server_peer := ENetMultiplayerPeer.new()
	
	server_peer.create_server(PORT)
	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene)

func _on_join_pressed() -> void:
	var client_peer := ENetMultiplayerPeer.new()
	#
	#
	#
	
	client_peer.create_client(get_local_ip(), PORT)
	multiplayer.multiplayer_peer = client_peer


func _on_connected_to_server():
	get_tree().change_scene_to_packed(main_scene)
