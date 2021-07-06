import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AccountScreen extends StatefulWidget {
  final User user;
  const AccountScreen({Key key, this.user}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _phoneno = new TextEditingController();
  bool _isEnable = false;
  // double screenHeight;
  // double screenWidth;

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('ACCOUNT'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300,
              child: Column(
                children: [
                  Text(
                    'Email: ' + widget.user.user_email,
                  ),
                  TextField(
                    controller: _username,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Username: ',
                        enabled: _isEnable,
                        icon: Icon(Icons.account_circle,
                            color: Colors.red.shade900)),
                  ),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEnable = true;
                        });
                      }),
                  TextField(
                    controller: _phoneno,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Phone No: ',
                        icon: Icon(Icons.phone_android_rounded,
                            color: Colors.red.shade900)),
                  ),
                  TextButton(
                      onPressed: () {
                        _done();
                      },
                      child: Text('Done'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _done() {
    String username = _username.text.toString();
    String phoneno = _phoneno.text.toString();

    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/account.php"),
        body: {
          "email": widget.user.user_email,
          "username": username,
          "phoneno": phoneno,
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Updated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
