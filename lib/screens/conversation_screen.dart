import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/services/database.dart';
import 'dart:async';

import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/colors.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ConversationScreen(this.chatRoomId, this.userName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextController = new TextEditingController();
  Stream chatMessages;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessages = val;
      });
    });
    super.initState();
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessages,
        builder: (context, snapshot) {
          Timer(
            Duration(milliseconds: 150),
            () => scrollController
                .jumpTo(scrollController.position.maxScrollExtent),
          );
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.docs[index]["message"],
                        snapshot.data.docs[index]["sentBy"] ==
                            Provider.of<UserProvider>(context, listen: false)
                                .name,
                        index,
                        snapshot.data.docs.length);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextController.text,
        "sentBy": Provider.of<UserProvider>(context, listen: false).name,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userName,
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessages != null ? chatMessageList() : Container(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message....",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: mainColor),
                          child: Icon(
                            Icons.send,
                            size: 25,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final int index;
  final int length;
  MessageTile(this.message, this.isSendByMe, this.index, this.length);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 4,
          right: isSendByMe ? 4 : 0),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      width: MediaQuery.of(context).size.width / 1.5,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: index == length - 1
              ? EdgeInsets.only(bottom: 80)
              : EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: isSendByMe ? mainColor : Colors.grey,
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 17, color: Colors.white),
          )),
    );
  }
}
