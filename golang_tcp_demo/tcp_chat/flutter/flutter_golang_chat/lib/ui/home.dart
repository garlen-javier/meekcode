import 'package:flutter/material.dart';
import 'package:flutter_golang_chat/manager/network_manager.dart';
import 'package:flutter_golang_chat/manager/socket_manager.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  SocketConnectionState _socketState = SocketConnectionState.NONE;

  @override
  void initState() {
    super.initState();
    SocketManager().connect(host: NetworkManager().host, port: NetworkManager().port);
    SocketManager().setConnectionListener((state) {
      setState(() {
        _socketState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textRowField("Room Name: ", _roomNameController),
            textRowField("User Name: ", _userNameController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                (_socketState == SocketConnectionState.CONNECTED)
                    ? TextButton(
                        onPressed: () {
                          String roomName = _roomNameController.value.text;
                          String userName = _userNameController.value.text;

                          if(userName.trim() == "" || roomName.trim() == ""){
                            final snackBar = SnackBar(content: Text('UserName and RoomName must not be empty!!'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }

                          SocketManager().joinRoom(
                            roomName: roomName,
                            userName: userName,
                            onJoin: ({userName, roomName}) {
                              Navigator.pushNamed(context, "Chat");
                            },
                          );
                        },
                        child: Text("Join Room"))
                    : TextButton(
                        onPressed: () {
                          SocketManager().connect(host: NetworkManager().host, port: NetworkManager().port);
                          SocketManager().setConnectionListener((state) {
                            setState(() {
                              _socketState = state;
                            });
                          });
                        },
                        child: Text("Connection Error: Retry?")),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "Connection");
                    },
                    child: Text("Change Connection")),
              ],
            )
          ],
        )));
  }

  Widget textRowField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}
