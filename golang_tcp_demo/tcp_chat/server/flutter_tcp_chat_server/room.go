package main

import "net"

type room struct {
	name    string
	clients map[net.Addr]*client
}

func newRoom(roomName string) *room {
	return &room{
		name:    roomName,
		clients: make(map[net.Addr]*client),
	}
}

func (instance *room) addClient(client *client) {
	client.currentRoom = instance
	instance.clients[client.conn.RemoteAddr()] = client
}

func (instance *room) removeClient(client *client) {
	client.currentRoom = nil
	delete(instance.clients, client.conn.RemoteAddr())
}

func (instance *room) broadcast(sender *client, msg string) {
	for key, value := range instance.clients {
		var addr = key
		var client = value

		if addr != sender.conn.RemoteAddr() {
			client.emitMessage(msg)
		}
	}
}
