import 'package:hicoder/models/enum/message_type.dart';

class Message {
  String? id;
  String? content;
  String? sender;
  String? receiver;
  MessageType? type;

  Message({
    this.id,
    this.content,
    this.sender,
    this.receiver,
    this.type,
  });
}
