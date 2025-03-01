import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app_flutter/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  // const ChatScreen({super.key});

  static String id = "ChatScreen";
  final _controller = ScrollController();
  final _focusNode = FocusNode(); // FocusNode to manage focus
  List messagesList = [];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;

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
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is ChatSuccess) {
                  messagesList = state.messages;
                }
              },
              builder: (context, state) {
                return ListView.builder(
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              focusNode: _focusNode,
              onSubmitted: (data) {
                controller.clear();
                _focusNode.requestFocus();
                _controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );

                BlocProvider.of<ChatCubit>(context).sendMessage(
                  message: data,
                  email: email,
                );
              },
              decoration: InputDecoration(
                hintText: "Send Message",
                suffixIcon: GestureDetector(
                  onTap: () {
                    // BlocProvider.of<ChatCubit>(context)
                    //     .sendMessage(message: , email: email);
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
  }
}

// void sendMessage(String email) {
//   if (controller.text.trim().isNotEmpty) {
//     messages.add(
//       {
//         kMessages: controller.text.trim(),
//         kMessageCreatedAt: DateTime.now(),
//         kMessageId: email,
//       },
//     );
//     controller.clear();
//     _focusNode.requestFocus();

//     // Scroll to the top of the ListView automatically
//     _controller.animateTo(
//       0,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeIn,
//     );

//     // jump to the end of the listView automatecally
//     // _controller.jumpTo(
//     //   _controller.position.maxScrollExtent,
//     // );
//   }
// }
