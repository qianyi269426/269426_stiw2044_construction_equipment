import 'package:construction_equipment/checkoutscreen.dart';
import 'package:construction_equipment/model/address.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PickAddress extends StatefulWidget {
  final User user;
  final Address address;
  
  const PickAddress({ Key key, this.user, this.address }) : super(key: key);

  @override
  _PickAddressState createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {
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
        title: Text('PICK ADDRESS'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
        
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
                        child: GestureDetector(
                          onTap: (){
                            _pass(index);
                          },
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
                                    
                                  ),
                                ),
                              ),
                              // IconButton(
                              //     alignment: Alignment.topRight,
                              //     icon: Icon(Icons.edit_outlined),
                              //     onPressed: () {
                              //       _edit();
                              //     })
                            ]),
                          ),
                        ),
                      ),
                    );
                  }));
            })
            ),
        ],
      )),
    );
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

  void _pass(index) {
    Address address = new Address(

      name: addresslist[index]['name'],
      phoneno: addresslist[index]['phoneno'],
      detailed_address: addresslist[index]['detailed_address'],
      area: addresslist[index]['area'],
      poscode: addresslist[index]['poscode'],
      state: addresslist[index]['state'],
      
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => CheckoutScreen(address: address, user: widget.user,)));
  }
}