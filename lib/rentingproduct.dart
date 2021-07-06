import 'package:cached_network_image/cached_network_image.dart';
import 'package:construction_equipment/model/product.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RentingProduct extends StatefulWidget {
  final Product product;
  final User user;

  const RentingProduct({Key key, this.product, this.user}) : super(key: key);
  @override
  _RentingProductState createState() => _RentingProductState();
}

class _RentingProductState extends State<RentingProduct> {
  double screenHeight;
  double screenWidth;
  int day = 0, qty = 1;
  double total = 0;

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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 30, 0),
                  height: screenHeight / 2.5,
                  // width: screenWidth/0.1,
                  child: CachedNetworkImage(
                    height: 180,
                    width: 240,
                    imageUrl:
                        "https://javathree99.com/s269426/constructorequipment/images/product/${widget.product.prid}.jpg",
                  ),
                ),
                // SizedBox(height: 15),
                // Text("  ID: "+widget.product.prid, style: TextStyle(fontSize: 18),),
                // SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text(
                    widget.product.prname,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text("Type: " + widget.product.prtype,
                      style: TextStyle(fontSize: 18)),
                ),
                // SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text("RM " + widget.product.prprice,
                      style: TextStyle(fontSize: 18, color: Colors.red)),
                ),
                // SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Text(
                    "Details: " + widget.product.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                // SizedBox(height: 3),
                // Text("  Stock(s): " + widget.product.prqty,
                //     style: TextStyle(fontSize: 18)),
                // SizedBox(height: 20),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.yellow,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              _setday("remove");
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                              child: Text(
                            day.toString() + " day(s)",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ))),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                _setday("add");
                              }),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                              child: Text(
                            "RM " + total.toStringAsFixed(2),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 22),
                          ))),
                    ],
                  ),
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
    if(total != 0){
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
        // _loadCart();
      }
        
    });}
    // print(widget.user.user_email);
    // print(widget.product.prid);
    // print(qty);
  }

  void _setday(String s) {
    setState(() {
      if (s == "add") {
        if(day <= 6){
          day++;
        }
        
      }
      if (s == "remove") {
        if (day != 0) {
          day--;
        }
      }
      total = day * double.parse(widget.product.prprice);
      print(double.parse(widget.product.prprice));
    });
  }
}
