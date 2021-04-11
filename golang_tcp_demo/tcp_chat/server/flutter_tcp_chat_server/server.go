package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
)

type server struct {
	clients map[net.Addr]*client
	rooms   map[string]*room
	events  chan event
}

func newServer() *server {
	return &server{
		clients: make(map[net.Addr]*client),
		rooms:   make(map[string]*room),
		events:  make(chan event),
	}
}

func (instance *server) handleClient(conn net.Conn) {
	client := newClient(conn, instance.events)
	client.readEvents()
	instance.clients[conn.RemoteAddr()] = client
}

func (instance *server) run() {
	for event := range instance.events {
		log.Println("Event: " + event.eventName)
		log.Println("args: " + event.args)

		switch event.eventName {
		case "joinRoom":
			instance.joinRoom(event.client, event.args)
		case "sendMessage":
			instance.sendMessage(event.client, event.args)
		case "leaveRoom":
			instance.leaveRoom(event.client)
		case "quit":
			instance.quit(event.client)
		default:
			event.client.errorMessage(fmt.Errorf("unkown event %s", event.eventName))
		}
	}
}

func (instance *server) joinRoom(client *client, args string) {
	var jsonMap map[string]string
	json.Unmarshal([]byte(args), &jsonMap)

	var roomName = jsonMap["roomName"]
	var userName = jsonMap["userName"]

	if roomName == "" || userName == "" {
		return
	}

	client.quitCurrentRoom()
	instance.updateRoomList(roomName)
	var room = instance.rooms[roomName]

	client.username = userName //joining room with defined username in front-end
	room.addClient(client)
	room.broadcast(client, composeGeneralMessage(RECEIVE_NOTICE_CALLBACK, userName+" has joined "+roomName))
	client.emitMessage(joinRoomCallback(userName, roomName))
	log.Println(userName + " has joined " + roomName)
}

func (instance *server) leaveRoom(client *client) {
	if client.currentRoom == nil {
		return
	}

	var userName = client.username
	var roomName = client.currentRoom.name

	client.currentRoom.broadcast(client, composeGeneralMessage(RECEIVE_NOTICE_CALLBACK, userName+" has left "+roomName))
	client.quitCurrentRoom()

	log.Println(userName + " has left " + roomName)
}

func (instance *server) sendMessage(client *client, args string) {
	if client.currentRoom == nil {
		client.errorMessage(fmt.Errorf("must join a room first"))
		return
	}

	var jsonMap map[string]string
	json.Unmarshal([]byte(args), &jsonMap)
	var msg = jsonMap["message"]

	client.emitMessage(composeMessage(SEND_MESSAGE_CALLBACK, client.username, msg))
	client.currentRoom.broadcast(client, composeMessage(RECEIVE_REPLY_CALLBACK, client.username, msg))

	log.Println("Room: " + client.currentRoom.name + " Sender: " + client.username + ": " + msg)
}

func (instance *server) quit(client *client) {
	log.Printf("client has disconnected : %s", client.conn.RemoteAddr().String())

	instance.clients[client.conn.RemoteAddr()] = nil
	client.quitCurrentRoom()
	client.emitMessage(composeGeneralMessage(SERVER_MESSAGE_CALLBACK, "bye"))
	client.conn.Close()
}

func (instance *server) updateRoomList(roomName string) {
	if _, exist := instance.rooms[roomName]; exist {
		if exist {
			return
		}
	}

	room := newRoom(roomName)
	instance.rooms[roomName] = room
}
