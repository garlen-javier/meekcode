import 'package:flutter/material.dart';
import 'package:flutter_golang_chat/ui/chat.dart';
import 'package:flutter_golang_chat/ui/connection.dart';
import 'package:flutter_golang_chat/ui/home.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter TCP Chat",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "Home",
      routes: {
        "Home": (context) => Home(),
        "Chat": (context) => Chat(),
        "Connection": (context) => Connection(),
      },
    );
  }
}
