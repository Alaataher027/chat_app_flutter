import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/models/message_model.dart';
import 'package:chat_app_flutter/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  // const ChatScreen({super.key});

  static String id = "ChatScreen";
  final _controller = ScrollController();
  final _focusNode = FocusNode(); // FocusNode to manage focus

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;
    // if (email == null) {
    //   print("the email is null");
    // }
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kMessageCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        // print(snapshot.data!.docs[0]['message']);

        if (snapshot.hasData) {
          // print(snapshot.data!.docs[0]['message']);
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 50,
                  ),
                  Text(
                    "Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: kprimaryColor,
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  // make the list view expand in the space
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messagesList[index].id == email
                          ? ChatBubble(
                              messageModel: messagesList[index],
                            )
                          : ChatBubbleForFriend(
                              messageModel: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller,
                    focusNode: _focusNode,
                    onSubmitted: (data) => sendMessage(email),
                    decoration: InputDecoration(
                      hintText: "Send Message",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          sendMessage(email);
                        },
                        child: Icon(
                          Icons.send_rounded,
                          color: kprimaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 130, 115, 47),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kprimaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Text("Loading..");
        }
      },
    );
  }

  void sendMessage(String email) {
    if (controller.text.trim().isNotEmpty) {
      messages.add(
        {
          kMessages: controller.text.trim(),
          kMessageCreatedAt: DateTime.now(),
          kMessageId: email,
        },
      );
      controller.clear();
      _focusNode.requestFocus();

      // Scroll to the top of the ListView automatically
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );

      // jump to the end of the listView automatecally
      // _controller.jumpTo(
      //   _controller.position.maxScrollExtent,
      // );
    }
  }
}
