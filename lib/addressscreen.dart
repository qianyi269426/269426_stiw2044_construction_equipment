import 'package:construction_equipment/addaddress.dart';
// import 'package:construction_equipment/editaddress.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressScreen extends StatefulWidget {
  final User user;

  const AddressScreen({Key key, this.user}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List addresslist = [];
  String _titlecenter = "Loading...";
  double screenHeight;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('MANAGE ADDRESS'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addAddress();
              })
        ],
      ),
      body: Center(
          child: Column(
        children: [
          if (addresslist.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(addresslist.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        child: Card(
                          child: Column(
                            children: [
                            Container(
                              child: Expanded(
                                flex: 3,
                                child: ListTile(
                                  title: Text(addresslist[index]['name'] +
                                      " " +
                                      addresslist[index]['phoneno'] +
                                      "\n"),
                                  subtitle: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: addresslist[index]
                                                ['detailed_address'] +
                                            " ",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                    TextSpan(
                                        text: addresslist[index]['area'] + " ",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                    TextSpan(
                                        text:
                                            addresslist[index]['poscode'] + " ",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                    TextSpan(
                                        text: addresslist[index]['state'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                  ])),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete_outline), color: Colors.red,
                                      onPressed: () {
                                        _deleteDialog(index);
                                      }),
                                ),
                              ),
                            ),
                            
                          ]),
                        ),
                      ),
                    );
                  }));
            })),
        ],
      )),
    );
  }

  // void _edit(index) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (content) => EditAddress(user: widget.user)));
  // }

  void _addAddress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => AddAddress(user: widget.user)));
//  print(widget.user.user_email);
  }

  void _loadAddress() {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/load_address.php"),
        body: {"email": widget.user.user_email}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        setState(() {
          var jsondata = json.decode(response.body);
          addresslist = jsondata["address"];
          print(addresslist);
        });
      }
    });
  }

  void _deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Delete"),
            content: Text("Are you sure to delete?"),
            actions: [
              TextButton(
                child: Text('Ok', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _delete(index);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
    
  }

  void _delete(int index) {
    // print(widget.user.user_email);
    // print(addresslist[index]['address_id']);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/delete_address.php"),
        body: {
          // "email": widget.user.user_email,
          "addressid": addresslist[index]['address_id'],
          // "prprice": addresslist[index]['prprice'],
          // "quantity": qty.toString(),
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
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadAddress();
      }
    });
  }
}
