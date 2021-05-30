import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Message_Model.dart';

// ignore: must_be_immutable
class Message extends StatefulWidget {
  String name;

  Message(String name) {
    this.name = name;
  }
  @override
  _MessageState createState() => _MessageState(this.name);
}

class _MessageState extends State<Message> {
  String name;
  _MessageState(String name) {
    this.name = name;
  }

  @override
  void initState() {
    super.initState();
  }

  double screenWidth, screenHeight;
  Query chats = FirebaseFirestore.instance
      .collection('Message')
      .orderBy('id', descending: true)
      .limit(8);
  // Query chats = FirebaseFirestore.instance.collection('Chat');
  var chat = new TextEditingController();

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Stream Cloud Firestore : ${this.name}',
        ),
        backgroundColor: Color(0xff0000b3),
      ),
      body: new SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
          child: Column(children: [
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.3, maxHeight: 50.0),
                  child: TextField(
                    controller: chat,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      prefixIcon: Icon(Icons.chat),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    double length = 0;
                    await FirebaseFirestore.instance
                        .collection('Message')
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                              querySnapshot.docs.forEach((doc) {
                                length++;
                              })
                            });
                    String date = DateTime.now().toIso8601String();
                    var model =
                        MessageModel(length, this.name, chat.text, date);
                    await model.addMessage();
                    chat.clear();
                  },
                  style: TextButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(80.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Sent",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
                stream: chats.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('error');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return new Column(
                    children: [
                      SizedBox(height: 15),
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              if (true) {
                                return listMessage(document);
                              }
                            }).toList(),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ],
                  );
                })
          ]),
        ),
      ),
    );
  }

  Widget listMessage(DocumentSnapshot document) {
    return Container(
      width: screenWidth,
      child: new Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
                width: 1, color: Color.fromARGB(255, 191, 191, 191))),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(
                        width: 1.0,
                        color: Color.fromARGB(255, 191, 191, 191)))),
            child: Icon(Icons.account_circle_sharp,
                color: Color(0xff0000ff), size: 40), // Hardcoded to be 'x'
          ),
          title: Wrap(
            spacing: 5,
            children: [
              new Text(
                '${document.data()['name']} : ${document.data()['text']}',
              ),
              SizedBox(height: 25)
            ],
          ),
          subtitle: new Text(
            '${document.data()['time']}',
          ),
          trailing: Wrap(
            spacing: 12,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () async {
                  String date = DateTime.now().toIso8601String();
                  var model =
                      MessageModel.update(document.id, 'ข้อความที่ส่งมาอัพเดทจ้าไปแต่งเอาเด้อน้องๆ', date);
                  await model.updateMessage();
                },
              ),
              if(document.data()['id'] == 0)
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.delete),
                  tooltip: 'Delete Chat ID: ${document.data()['id']}',
                  onPressed: () async {

                  },
                )
              else
                 IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.delete),
                  tooltip: 'Delete Chat ID: ${document.data()['id']}',
                  onPressed: () async {
                    if(document.data()['id'] != 0){
                      var model = MessageModel.delete(document.id);
                      await model.deleteMessage();
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
