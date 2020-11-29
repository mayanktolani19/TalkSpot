import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talk_spot/helper/constants.dart';
import 'package:talk_spot/helper/helperfunctions.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/conversation_screen.dart';
import 'package:talk_spot/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  TextEditingController searchTextEditingController =
      new TextEditingController();
  bool mine = false;
  bool found = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions().getUserName();
    setState(() {});
  }

  initiateSearch() async {
    await databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      try {
        print(searchSnapshot.documents[0]);
        setState(() {
          found = true;
        });
      } catch (e) {
        print(e);
        setState(() {
          found = false;
        });
      }
      searchSnapshot = val;
    });
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoom(String userName) {
    if (Constants.myName != userName) {
      print(Constants.myName);
      print(userName);
      List<String> users = [Constants.myName, userName];
      String chatRoomId = getChatRoomId(Constants.myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId, userName)));
    } else {
      setState(() {
        mine = true;
      });
      print("You cannot send message to yourself");
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(searchSnapshot.documents[index].data["name"],
                  searchSnapshot.documents[index].data["email"]);
            })
        : Container();
  }

  Widget searchTile(String userName, String userEmail) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  userName,
                  style: simpleTextFieldStyle(),
                ),
                Text(userEmail, style: simpleTextFieldStyle()),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoom(userName);
              },
              child: Container(
                child: Text(
                  'Message',
                  style: simpleTextFieldStyle(),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search UserName....",
                        hintStyle: TextStyle(color: Colors.white54)),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.blueGrey),
                        child: Icon(
                          Icons.search,
                          size: 25,
                        )),
                  )
                ],
              ),
            ),
            searchList(),
            !found
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(
                          'assets/images/searchImg3.png',
                          color: Colors.blue,
                        ),
                      ),
                      searchTextEditingController.text == null
                          ? Text(
                              'Search for a UserName.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 32,
                              ),
                            )
                          : !found
                              ? Text(
                                  'Search for a UserName.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 32,
                                  ),
                                )
                              : Container(),
                    ],
                  )
                : Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(
                        'assets/images/searchImg3.png',
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Not able to found the SserName you were looking for.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 32,
                      ),
                    )
                  ])
          ],
        ),
      ),
    );
  }
}
