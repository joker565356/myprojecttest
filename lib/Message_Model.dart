import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  double chatId;
  String docId;
  String chatName;
  String chatText;
  String chatTime;

  MessageModel(double chatId, String chatName, String chatText, String chatTime) {
    this.chatId = chatId;
    this.chatName = chatName;
    this.chatText = chatText;
    this.chatTime = chatTime;
  }
  MessageModel.update(String docId, String chatText, String chatTime) {
    this.docId = docId;
    this.chatText = chatText;
    this.chatTime = chatTime;
  }
  MessageModel.delete(String docId) {
    this.docId = docId;
  }



  CollectionReference chat = FirebaseFirestore.instance.collection('Message');
  Future<void> addMessage() async {
    chat
        .add({
          'id': this.chatId,
          'name': this.chatName,
          'text': this.chatText,
          'time': this.chatTime,
        })
        .then((value) => print("Chat Added"))
        .catchError((error) => print("Failed to add Chat: $error"));
  }
  Future<void> updateMessage() async {
    chat.doc(this.docId).update({
      'text': this.chatText,
      'time': this.chatTime,
    })
    .then((value) => print("Condo Updated"))
    .catchError((error) => print("Failed to update Chat : $error"));
  }
  Future<void> deleteMessage() async {
    chat.doc(this.docId).delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete Chat: $error"));
  }
}
