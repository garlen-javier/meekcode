
import 'package:meta/meta.dart';

class Message{
  String sender;
  String content;
  String timeStamp;

  Message({
    @required this.sender,
    @required this.content,
    this.timeStamp
  });
}