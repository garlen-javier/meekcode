package main

import (
	"encoding/json"
	"time"
)

const (
	JOINROOM_CALLBACK       = "onJoinRoom"
	SEND_MESSAGE_CALLBACK   = "onSendMessage"
	SERVER_MESSAGE_CALLBACK = "onServerMessage"
	RECEIVE_REPLY_CALLBACK  = "onReceiveReply"
	RECEIVE_NOTICE_CALLBACK = "onReceiveNotice"
	RECEIVE_ERROR_CALLBACK  = "onReceiveError"
)

type message struct {
	Sender    string `json:"sender"`
	Username  string `json:"username"`
	Roomname  string `json:"roomname"`
	Message   string `json:"message"`
	TimeStamp string `json:"timeStamp"`
}

func composeMessage(messageType string, sender string, msg string) string {
	content := make(map[string]message)
	content[messageType] = message{
		Sender:    sender,
		Message:   msg,
		TimeStamp: time.Now().String(),
	}

	jsonByte, err := json.Marshal(content)
	if err != nil {
		return ""
	}

	return string(jsonByte)
}

func composeGeneralMessage(messageType string, msg string) string {
	content := make(map[string]message)
	content[messageType] = message{
		Message:   msg,
		TimeStamp: time.Now().String(),
	}

	jsonByte, err := json.Marshal(content)
	if err != nil {
		return ""
	}

	return string(jsonByte)
}

func joinRoomCallback(username string, roomname string) string {
	content := make(map[string]message)
	content[JOINROOM_CALLBACK] = message{
		Username:  username,
		Roomname:  roomname,
		TimeStamp: time.Now().String(),
	}

	jsonByte, err := json.Marshal(content)
	if err != nil {
		return ""
	}

	return string(jsonByte)
}
