import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  final User user;

  const ContactScreen({Key key, this.user}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONTACT US'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              shadowColor: Colors.red.shade900,
              margin: EdgeInsets.fromLTRB(10, 150, 10, 5),
              elevation: 10,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(27),
                      child: Text(
                        'Admin: Construction Equipment',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      padding: EdgeInsets.all(27),
                      child: Text('Contact: 019-4466227',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
