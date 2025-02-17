import 'package:chat_app_flutter/constants.dart';

class MessageModel {
  final String message;
  final String id;

  MessageModel(this.message, this.id);

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      jsonData[kMessages],
      jsonData[kMessageId],
    );
  }
}
