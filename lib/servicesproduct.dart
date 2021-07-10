import 'package:cached_network_image/cached_network_image.dart';
import 'package:construction_equipment/model/product.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ServicesProduct extends StatefulWidget {
  final Product product;
  final User user;

  const ServicesProduct({Key key, this.product, this.user}) : super(key: key);
  @override
  _ServicesProductState createState() => _ServicesProductState();
}

class _ServicesProductState extends State<ServicesProduct> {
  double screenHeight;
  double screenWidth;
  TextEditingController _feetController = new TextEditingController();
  double total = 0;
  int day = 0, qty = 1;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('HOMEPAGE'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 30, 0),
                  height: screenHeight / 2.5,
                  child: CachedNetworkImage(
                    height: 180,
                    width: 240,
                    imageUrl:
                        "https://javathree99.com/s269426/constructorequipment/images/product/${widget.product.prid}.jpg",
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text(
                    widget.product.prname,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text("Type: " + widget.product.prtype,
                      style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text("RM " + widget.product.prprice,
                      style: TextStyle(fontSize: 18, color: Colors.red)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text(
                    "Details: " + widget.product.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      height: 50,
                      width: 100,
                      child: TextField(
                        controller: _feetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "feet",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {_calTotalPrice()},
                      child: Text("Calculate"),
                      style: ElevatedButton.styleFrom(primary: Colors.red[900]),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          child: Text(
                        "RM " + total.toStringAsFixed(2),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 22),
                      )),
                    )
                  ]),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => {_addtocart()},
                    child: Text("+ Cart"),
                    style: ElevatedButton.styleFrom(primary: Colors.red[900]),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  _addtocart() {
    if (total != 0) {
      http.post(
          Uri.parse(
              "https://javathree99.com/s269426/constructorequipment/php/insertcart.php"),
          body: {
            "email": widget.user.user_email,
            "prid": widget.product.prid,
            "prprice": total.toString(),
            "prqty": qty.toString(),
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
        }
      });
    }
    // print(widget.user.user_email);
    // print(widget.product.prid);
    // print(qty);
  }

  _calTotalPrice() {
    setState(() {
      total = double.parse(widget.product.prprice) *
          double.parse(_feetController.text);
    });
  }
}
