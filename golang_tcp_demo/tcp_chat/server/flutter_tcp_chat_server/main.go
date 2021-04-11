package main

import (
	"log"
	"net"
)

const (
	live_port       = "8888"
	genymotion_port = "5555"
)

func main() {
	log.Println("Starting...")
	var port = genymotion_port
	server := newServer()
	go server.run()

	listener, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("unable to start server :%s", err.Error())
	}

	defer listener.Close()
	log.Println("Server listening on port:" + port)

	for {
		conn, err := listener.Accept()
		if err != nil {
			continue
		}

		go server.handleClient(conn)
	}
}
