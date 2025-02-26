import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  // TextEditingController controller = TextEditingController();

  void sendMessage({required String message, required String email}) {
    // if (controller.text.trim().isNotEmpty) {
    try {
      messages.add(
        {
          kMessages: message,
          kMessageCreatedAt: DateTime.now(),
          kMessageId: email,
        },
      );
    } on Exception catch (e) {
      // TODO
    }
    // }
  }

  void getMessages() {
    messages
        .orderBy(kMessageCreatedAt, descending: true)
        .snapshots()
        .listen((event) {
      List<MessageModel> messagesList = [];
      for (var doc in event.docs) {
        messagesList.add(MessageModel.fromJson(doc));
      }
      emit(ChatSuccess(
          messages: messagesList)); // success after the data is fetched
    });
  }
}
