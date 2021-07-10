import 'package:cached_network_image/cached_network_image.dart';
import 'package:construction_equipment/checkoutscreen.dart';
import 'package:construction_equipment/model/address.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final User user;
  final Address address;

  const CartScreen({Key key, this.user, this.address}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _titlecenter = "Loading...";
  List _cartList = [];
  double _totalprice;
  int qty = 0;

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CART'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
          child: Column(
        children: [
          if (_cartList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              _update(index, "remove");
                                            },
                                          ),
                                          Text(_cartList[index]['prqty']),
                                          IconButton(
                                            icon:
                                                Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              _update(index, "add");
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RM " + _cartList[index]['total_price'],
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_sharp),
                                    color: Colors.red,
                                    onPressed: () {
                                      _deletecart(index);
                                    },
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    );
                  }));
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
                      child: Text("CHECKOUT"),
                      onPressed: () {
                        _checkout();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red[900]))
                ],
              )),
        ],
      )),
    );
  }

  void _update(int index, String s) {
    qty = int.parse(_cartList[index]['prqty']);
    if (s == "add") {
      qty++;
    }
    if (s == "remove") {
      if (qty != 0) {
        qty--;
      }
      if (qty == 0) {
        return;
      }
    }
    print(qty);
    print(widget.user.user_email);
    print(_cartList[index]['prid']);
    print(_cartList[index]['prprice']);

    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/updatecart.php"),
        body: {
          "email": widget.user.user_email,
          "prid": _cartList[index]['prid'],
          "prprice": _cartList[index]['prprice'],
          "quantity": qty.toString(),
        }).then((response) {
      print(response.body);

      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      }
    });
  }

  void _deletecart(int index) {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/deletecart.php"),
        body: {
          "email": widget.user.user_email,
          "prid": _cartList[index]['prid'],
          "prprice": _cartList[index]['prprice'],
          // "quantity": qty.toString(),
        }).then((response) {
      print(response.body);

      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Deleted! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      }
    });
  }

  void _checkout() {
    Address address = new Address(
        name: " ",
        phoneno: " ",
        detailed_address: " ",
        area: " ",
        poscode: " ",
        state: " ");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) =>
                CheckoutScreen(user: widget.user, address: address)));
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
