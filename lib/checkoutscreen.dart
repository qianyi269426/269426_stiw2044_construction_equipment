import 'package:construction_equipment/model/address.dart';
import 'package:construction_equipment/model/pay.dart';
import 'package:construction_equipment/payment.dart';
import 'package:construction_equipment/pickAddress.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutScreen extends StatefulWidget {
  final User user;
  final Address address;
  final Pay pay;

  const CheckoutScreen({Key key, this.user, this.address, this.pay})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController _messageController = new TextEditingController();
  double _totalprice;
  List addresslist = [];
  // double screenHeight;
  // double screenWidth;
  // String _curtime = "";
  String _titlecenter = "Loading...";
  List _cartList = [];
  // String date1;
 

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHECKOUT'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
          child: Column(
        children: [
           Container(
                      height: 80,
                      width: 310,
                      // color: Colors.yellow,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (content) =>
                                      PickAddress(user: widget.user)));
                          // print(widget.address.name);
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                child: Expanded(
                                  flex: 3,
                                  child: ListTile(
                                    title: Text(
                                      "Delivery Address:",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: widget.address.name +
                                                " " +
                                                widget.address.phoneno +
                                                "\n",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14)),
                                        TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: widget.address
                                                      .detailed_address +
                                                  " ",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14)),
                                          TextSpan(
                                              text: widget.address.area + " ",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14)),
                                          TextSpan(
                                              text:
                                                  widget.address.poscode + " ",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14)),
                                          TextSpan(
                                              text: widget.address.state,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14)),
                                        ])
                                      ]),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
          Container(
            height: 65,
            width: 304,
            // color: Colors.yellow,
            child: Card(
              margin: EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                       keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Additional message:',
                          labelStyle: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 45,
            width: 310,
            child: Card(
                child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 12, 31, 00, 00),
                          maxTime: DateTime(2025, 12, 31, 23, 59),
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print(date);
                        // date1=date.toString();
                        // print(date1);
                      }, locale: LocaleType.en);
                    },
                    child: Text(
                      'Pick a Delivery Time',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            )),
          ),
          if (_cartList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return Container(
                width: 310,
                // height: 10,
                // color: Colors.yellow,
                child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    children: List.generate(_cartList.length, (index) {
                      return Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          child: Card(
                            child: Row(children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                  height: 100,
                                  width: 150,
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          "https://javathree99.com/s269426/constructorequipment/images/product/${_cartList[index]['prid']}.jpg"),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _cartList[index]['prname'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "RM " +
                                              _cartList[index]['total_price'],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        )
                                      ],
                                    )),
                              ),
                            ]),
                          ),
                        ),
                      );
                    })),
              );
            })),
          Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 5),
                  Divider(
                    color: Colors.red,
                    height: 1,
                    thickness: 10.0,
                  ),
                  Text(
                    "TOTAL RM " + _totalprice.toStringAsFixed(2),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      child: Text("PAY"),
                      onPressed: () {
                        _pay();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red[900]))
                ],
              )),
        ],
      )),
    );
  }

  void _pay() {
    String _message= _messageController.text.toString();
    // String date= widget.pay.delivery_time;

    print(_message);

    Pay pay = new Pay(
      totalprice: _totalprice,
      addmessage: _message,
      // delivery_time: widget.pay.delivery_time ,
      // delivery_time: date.toString(),
      // delivery_time: date1
      );

    Address address = new Address(
        name: widget.address.name,
        phoneno: widget.address.phoneno,
        detailed_address: widget.address.detailed_address,
        poscode: widget.address.poscode,
        area: widget.address.area,
        state: widget.address.state
        );

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (content) =>
                Payment(user: widget.user, address: address, pay: pay)));
  }

  void _loadMyCart() {
    _totalprice = 0.0;
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadcart.php"),
        body: {"email": widget.user.user_email}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        setState(() {
          var jsondata = json.decode(response.body);
          _cartList = jsondata["cart"];
          print(_cartList);
          for (int index = 0; index < _cartList.length; index++) {
            _totalprice =
                double.parse(_cartList[index]['total_price']) + _totalprice;
          }
        });
      }
    });
  }
}
