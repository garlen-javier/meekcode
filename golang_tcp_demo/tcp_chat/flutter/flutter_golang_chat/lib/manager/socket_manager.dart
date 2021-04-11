import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

typedef MessageType({String sender,String message,String timeStamp});
typedef GeneralMessageType({String message,String timeStamp});

enum SocketConnectionState {
  NONE,
  CONNECTED,
  ERROR,
  DISCONNECTED,
}

class SocketManager {
  Socket _socket;
  StreamSubscription _socketListener;

  MessageType _onSendMessage;
  MessageType _onReceiveReply;
  GeneralMessageType _onServerMessage;
  GeneralMessageType _onReceiveNotice;
  GeneralMessageType _onReceiveError;
  Function({@required String userName,@required String roomName}) _onJoin;
  Function(SocketConnectionState state) _connectionStateListener;

  SocketManager._constructor();
  static final SocketManager _instance = SocketManager._constructor();

  factory SocketManager() {
    return _instance;
  }

  Future<void> connect({@required String host, @required int port}) async {
    try {
      _socket = await Socket.connect(host, port);
      _initSocketListener();
      if(_connectionStateListener != null)
        _connectionStateListener(SocketConnectionState.CONNECTED);
    }
    catch(e){
      if(_connectionStateListener != null)
        _connectionStateListener(SocketConnectionState.ERROR);
    }
    // socket.close();
  }

  void _initSocketListener(){
    if(_socketListener != null)
      {
        _socketListener.cancel();
        _socketListener = null;
      }
    if (_socketListener == null) {
      _socketListener = _socket.listen((data) {
        String jsonData = utf8.decode(data);
        print("JSON data = " + jsonData);
        Map<String, dynamic> map = jsonDecode(jsonData);
        map.forEach((key, value) {
          String messageType = key;
          Map<String, dynamic> mapVal = value;
          switch (messageType) {
            case "onSendMessage":
              String sender = mapVal["sender"].toString();
              String msg = mapVal["message"].toString();
              String timeStamp = mapVal["timeStamp"].toString();
              if(_onSendMessage != null)
                _onSendMessage(sender:sender,message: msg,timeStamp:timeStamp);
              break;
            case "onReceiveReply":
              String sender = mapVal["sender"].toString();
              String msg = mapVal["message"].toString();
              String timeStamp = mapVal["timeStamp"].toString();
              if(_onReceiveReply != null)
                _onReceiveReply(sender:sender,message: msg,timeStamp:timeStamp);
              break;
            case "onServerMessage":
              String msg = mapVal["message"].toString();
              String timeStamp = mapVal["timeStamp"].toString();
              if(_onServerMessage != null)
                _onServerMessage(message: msg,timeStamp:timeStamp);
              break;
            case "onReceiveNotice":
              String msg = mapVal["message"].toString();
              String timeStamp = mapVal["timeStamp"].toString();
              if(_onReceiveNotice != null)
                _onReceiveNotice(message: msg,timeStamp:timeStamp);
              break;
            case "onReceiveError":
              String msg = mapVal["message"].toString();
              String timeStamp = mapVal["timeStamp"].toString();
              if(_onReceiveError != null)
                _onReceiveError(message: msg,timeStamp:timeStamp);
              break;
            case "onJoinRoom":
              String userName = mapVal["username"].toString();
              String roomName = mapVal["roomname"].toString();
              if(_onJoin != null)
                _onJoin(userName:userName,roomName:roomName);
              break;
          }
        });
      },onDone: (){
        if(_connectionStateListener != null)
          _connectionStateListener(SocketConnectionState.DISCONNECTED);
      });
    }
  }

  void setConnectionListener(Function(SocketConnectionState state) listener){
    _connectionStateListener = listener;
  }

  void joinRoom({@required String roomName, @required String userName, Function({@required String userName,@required String roomName}) onJoin}) {
    _onJoin = onJoin;
    Map<String, String> args = Map<String, String>();
    args["roomName"] = roomName;
    args["userName"] = userName;
    _sendEventArgs(eventName: "joinRoom", args: args);
  }

  void leaveRoom() {
    _callEvent(eventName: "leaveRoom");
  }

  void disconnect() {
    _callEvent(eventName: "quit");
    _socketListener.cancel();
  }

  void sendMessage({@required message,MessageType onSendMessage}) {
    _onSendMessage = onSendMessage;

    Map<String, String> args = Map<String, String>();
    args["message"] = message;
    _sendEventArgs(eventName: "sendMessage", args: args);
  }

  void onReceiveReply(MessageType listener) => _onReceiveReply = listener;
  void onServerMessage(MessageType listener) => _onServerMessage = listener;
  void onReceiveNotice(MessageType listener) => _onReceiveNotice = listener;
  void onReceiveError(MessageType listener) => _onReceiveError = listener;

  void _sendEventArgs(
      {@required String eventName, @required Map<String, String> args}) {
    if (_socket == null) {
      print("Socket not initialize");
      return;
    }

    Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData["event"] = eventName;
    jsonData["args"] = args;
    _socket.writeln(JsonEncoder().convert(jsonData));
  }

  void _callEvent({@required String eventName}) {
    if (_socket == null) {
      print("Socket not initialize");
      return;
    }

    Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData["event"] = eventName;
    _socket.writeln(JsonEncoder().convert(jsonData));
  }
}
