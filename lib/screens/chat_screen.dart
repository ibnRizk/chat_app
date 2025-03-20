import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chattt/components/message.dart';
import 'package:flash_chattt/costants.dart';
import 'package:flutter/material.dart';

import '../components/chat_buble.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final controllerr = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessagesCollection);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: null,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.close), onPressed: () {}),
              ],
              title: Center(child: Text('⚡️Chat')),
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: controllerr,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? Chatbuble(
                              message: messagesList[index],
                            )
                          : ChatbubleForFriend(
                              message: messagesList[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      messages.add(
                        {
                          'message': value,
                          'createdAt': DateTime.now(),
                          'id': email
                        },
                      );
                      controller.clear();
                      controllerr.animateTo(0,
                          duration: Duration(seconds: 1), curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                      hintText: 'Send a Message',
                      suffix: Icon(Icons.send),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
