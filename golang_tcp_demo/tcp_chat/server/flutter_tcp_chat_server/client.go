package main

import (
	"bufio"
	"fmt"
	"io"
	"net"

	"github.com/tidwall/gjson"
)

type client struct {
	conn        net.Conn
	username    string
	currentRoom *room
	events      chan<- event
}

func newClient(conn net.Conn, serverEvents chan<- event) *client {
	return &client{
		conn:   conn,
		events: serverEvents,
	}
}

func (instance *client) readEvents() {
	reader := bufio.NewReader(instance.conn)
	for {
		str, err := reader.ReadString('\n')
		if err != nil {
			if err != io.EOF {
				//TODO: remove
				fmt.Println("failed to read data, err:", err)
			}
			return
		}
		//TODO: use value if not testing
		//fmt.Println(str)
		// var joinRoom = "{\"event\": \"joinRoom\",\"args\": {\"roomName\": \"testRoom\",\"userName\": \"user4321\"} }"

		var eventName = gjson.Get(str, "event").String()
		var args = gjson.Get(str, "args").String()

		if eventName == "" {
			continue
		}

		instance.events <- event{
			eventName: eventName,
			args:      args,
			client:    instance,
		}
	}
}

func (instance *client) emitMessage(msg string) {
	instance.conn.Write([]byte(msg))
}

func (instance *client) errorMessage(err error) {
	instance.conn.Write([]byte("ERROR: " + err.Error() + "\n"))
}

func (instance *client) quitCurrentRoom() {
	if instance.currentRoom != nil {
		instance.currentRoom.removeClient(instance)
	}
}
