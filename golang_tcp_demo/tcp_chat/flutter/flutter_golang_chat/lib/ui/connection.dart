import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_golang_chat/manager/network_manager.dart';
import 'package:flutter_golang_chat/manager/socket_manager.dart';

class Connection extends StatelessWidget {
  final TextEditingController _hostController = TextEditingController(text: NetworkManager().host);
  final TextEditingController _portController = TextEditingController(text: NetworkManager().port.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connection Setting"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textRowField("Host IP: ", _hostController, TextInputType.text),
            textRowField("Port: ", _portController, TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            TextButton(
                onPressed: () {
                  String host = _hostController.value.text;
                  int port = (_portController.value.text.length <= 0 ) ? 0 : int.parse(_portController.value.text);
                  SocketManager().connect(host: host, port: port);
                  SocketManager().setConnectionListener((state) {
                    if (state == SocketConnectionState.CONNECTED) {
                      NetworkManager().updateAddress(hostIP: host, portNum: port);
                      Navigator.pop(context);
                    } else if (state == SocketConnectionState.ERROR) {
                      final snackBar = SnackBar(content: Text('Connection Error!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
                child: Text("Update"))
          ],
        )));
  }

  Widget textRowField(String title, TextEditingController controller, TextInputType keyboardType,{List<TextInputFormatter> inputFormatters}) {
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
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            ),
          )
        ],
      ),
    );
  }
}
