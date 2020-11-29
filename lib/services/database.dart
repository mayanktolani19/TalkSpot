import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    try {
      return await Firestore.instance
          .collection("users")
          .where("name", isEqualTo: username)
          .getDocuments();
    } catch (e) {
      return e;
    }
  }

  getUserByUserEmail(String userEmail) async {
    try {
      return await Firestore.instance
          .collection("users")
          .where("email", isEqualTo: userEmail)
          .getDocuments();
    } catch (e) {
      print(e);
      return (e);
    }
  }

  uploadUserInfo(userMap, google) async {
    bool save = true;
    if (google) {
      var a = await Firestore.instance.collection("users").getDocuments();
      for (int i = 0; i < a.documents.length; i++) {
        if (a.documents[i]["email"] == userMap["email"]) {
          save = false;
          break;
        }
      }
    }
    if (save) await Firestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  getConversationMessages(String chatRoomId) async {
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
