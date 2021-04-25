import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_spot/screens/signin.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/conversation_screen.dart';
import 'package:talk_spot/screens/search.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  @override
  void initState() {
    print("Chat room");
    databaseMethods
        .getChatRooms(Provider.of<UserProvider>(context, listen: false).name)
        .then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
    super.initState();
  }

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    authMethods.signOut();
    GoogleSignIn googleSignIn = new GoogleSignIn();
    bool a = await googleSignIn.isSignedIn();
    if (a) await googleSignIn.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.docs[index]["chatRoomId"]
                        .toString()
                        .contains(
                            Provider.of<UserProvider>(context, listen: false)
                                .name)) {
                      return ChatRoomTile(
                          snapshot.data.docs[index]["chatRoomId"]
                              .toString()
                              .replaceAll("_", "")
                              .replaceAll(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .name,
                                  ""),
                          snapshot.data.docs[index]["chatRoomId"]);
                    }
                    return Container();
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: chatRoomList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        ),
        appBar: AppBar(
          title: Text(
            'TalkSpot - ' +
                        Provider.of<UserProvider>(context, listen: false)
                            .name !=
                    null
                ? Provider.of<UserProvider>(context, listen: false).name
                : ' ',
            style: TextStyle(fontSize: 22),
          ),
          backgroundColor: Color.fromRGBO(13, 35, 197, 80),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.blue[900],
                        title: Text(
                          'Are you sure you want to logout?',
                          style: simpleTextFieldStyle(),
                        ),
                        content: Text(
                          'We hate to see you leave...',
                          style: simpleTextFieldStyle(),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('No'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              logoutUser();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ));
  }
}

class ChatRoomTile extends StatelessWidget {
  final String chatRoomId;
  final String userName;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId, userName)));
      },
      child: Container(
          //margin: EdgeInsets.only(bottom: 8),
          color: Colors.black54,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 22),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(fontSize: 19),
                ),
              ),
              SizedBox(width: 10),
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          )),
    );
  }
}
