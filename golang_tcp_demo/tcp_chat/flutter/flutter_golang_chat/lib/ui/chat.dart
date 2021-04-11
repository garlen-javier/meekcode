import 'package:flutter/material.dart';
import 'package:flutter_golang_chat/manager/socket_manager.dart';
import 'package:flutter_golang_chat/model/message.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Message> _messageList = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SocketManager().onReceiveReply(({message, sender, timeStamp}) {
      print("receive reply");
      Message msg = Message(sender: sender,content: message,timeStamp: timeStamp);
      setState(() {
        _messageList.add(msg);
      });
    } );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat Room: "),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          Message message = _messageList[index];
          return ChatTile(message: message);
        },
        itemCount: _messageList.length,
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: TextField(controller: _messageController,)),
            TextButton(
                onPressed: () {
                  SocketManager().sendMessage(message: _messageController.value.text ,onSendMessage: ({message, sender, timeStamp}) {
                    _messageController.clear();
                    Message msg = Message(sender: sender,content: message,timeStamp: timeStamp);
                    setState(() {
                      _messageList.add(msg);
                    });
                  },);
                },
                child: Text("Send"))
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final Message message;
  ChatTile({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Sender: " + message.sender),
            SizedBox(
              width: 10,
            ),
            Text("Message: " + message.content),
          ],
        ),
      ),
    );
  }
}
