import 'package:flutter/material.dart';
import 'Message.dart';

// ignore: must_be_immutable
class HomePageName extends StatefulWidget {
  @override
  _HomePageNameState createState() => _HomePageNameState();
}

class _HomePageNameState extends State<HomePageName> {
  @override
  void initState() {
    super.initState();
  }

  double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    var name = new TextEditingController();
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff0000b3), Color(0xff0000ff)])),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: screenHeight * 0.25),
            Container(
              constraints: BoxConstraints(minWidth: 350.0, minHeight: 220.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(blurRadius: 6),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, maxHeight: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nickname :',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  textFieldLogin(
                      context,
                      name,
                      Icon(Icons.supervised_user_circle_rounded),
                      'Nickname',
                      false),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Message(name.text.trim())));
                      // builder: (context) => Chat2()));
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
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Go to Chat",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget textFieldLogin(BuildContext context, TextEditingController controller,
      Icon icon, String label, bool hideText) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300.0, maxHeight: 50.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 18),
        obscureText: hideText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.amber,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
