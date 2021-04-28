import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:talk_spot/screens/signin.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/conversation_screen.dart';
import 'package:talk_spot/screens/search.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/colors.dart';
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
      body: SlideDrawer(
        backgroundColor: mainColor,
        drawer: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Drawer(
              elevation: 1000,
              child: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    border: Border.all(
                      color: mainColor,
                    ),
                  ),
                  child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                    DrawerHeader(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: SafeArea(
                                child: Image.asset(
                                    'assets/images/splash-icon.png',
                                    height: 64,
                                    width: 64),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('TalkSpot'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Theme',
                        ),
                        LiteRollingSwitch(
                          //initial value
                          value: true,
                          textOn: 'Dark',
                          textOff: 'Light',
                          colorOn: Colors.black,
                          colorOff: mainColor,
                          iconOn: Icons.nightlight_round,
                          iconOff: Icons.wb_sunny,
                          textSize: 16.0,
                          onTap: () {
                            getThemeManager(context).toggleDarkLightTheme();
                          },
                          onChanged: (bool state) {
                            //Use it to manage the different states
                            print('Current State of SWITCH IS: $state');
                          },
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
        // items: [
        //   MenuItem('Home', onTap: () {}, leading: Icon(Icons.home)),
        //   MenuItem('Project', onTap: () {}),
        //   MenuItem('Favourite', onTap: () {}),
        //   MenuItem('Profile', onTap: () {}),
        //   MenuItem('Setting', onTap: () {}),
        // ]
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      // call toggle from SlideDrawer to alternate between open and close
                      // when pressed menu button
                      onPressed: () => SlideDrawer.of(context).toggle(),
                    ),
                    expandedHeight: 50.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("TalkSpot",
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ),
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
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No'),
                                    ),
                                    MaterialButton(
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
                    ])
              ];
            },
            body: chatRoomList()),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      // appBar: AppBar(
      //   title: Text(
      //     'TalkSpot - ' +
      //                 Provider.of<UserProvider>(context, listen: false)
      //                     .name !=
      //             null
      //         ? Provider.of<UserProvider>(context, listen: false).name
      //         : ' ',
      //     style: TextStyle(fontSize: 22),
      //   ),
      //   backgroundColor: Color.fromRGBO(13, 35, 197, 80),
      //   actions: <Widget>[
      //     GestureDetector(
      //       onTap: () {
      //         showDialog(
      //             context: context,
      //             builder: (context) {
      //               return AlertDialog(
      //                 backgroundColor: Colors.blue[900],
      //                 title: Text(
      //                   'Are you sure you want to logout?',
      //                   style: simpleTextFieldStyle(),
      //                 ),
      //                 content: Text(
      //                   'We hate to see you leave...',
      //                   style: simpleTextFieldStyle(),
      //                 ),
      //                 actions: <Widget>[
      //                   FlatButton(
      //                     onPressed: () {
      //                       Navigator.of(context).pop(false);
      //                     },
      //                     child: Text('No'),
      //                   ),
      //                   FlatButton(
      //                     onPressed: () {
      //                       Navigator.pop(context);
      //                       logoutUser();
      //                     },
      //                     child: Text('Yes'),
      //                   ),
      //                 ],
      //               );
      //             });
      //       },
      //       child: Container(
      //           padding: EdgeInsets.symmetric(horizontal: 16),
      //           child: Icon(Icons.exit_to_app)),
      //     )
      //   ],
      // ),
    );
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
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: mainColor),
            borderRadius: BorderRadius.circular(20),
          ),
          // margin: EdgeInsets.only(left),
          // color: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 22),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(100)),
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Text(
                userName,
                style: TextStyle(fontSize: 18),
              ),
            ],
          )),
    );
  }
}
