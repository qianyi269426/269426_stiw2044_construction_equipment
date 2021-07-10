import 'package:construction_equipment/accountscreen.dart';
import 'package:construction_equipment/addressscreen.dart';
import 'package:construction_equipment/cartscreen.dart';
import 'package:construction_equipment/contactscreen.dart';
import 'package:construction_equipment/productscreen.dart';
import 'package:construction_equipment/loginscreen.dart';
import 'package:construction_equipment/model/product.dart';
import 'package:construction_equipment/rentingproduct.dart';
import 'package:construction_equipment/servicesproduct.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight;
  double screenWidth;
  List productlist = [];
  String _titlecenter = "Loading...";
  TextEditingController _prnameController = new TextEditingController();
  int sortButton = 1;
  int cartitem = 0;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('HOMEPAGE'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
        actions: [
          IconButton(
              icon: Icon(Icons.category_outlined),
              onPressed: () {
                _category(context);
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.red.shade900),
            ),
            ListTile(
              title: Text("My Profile", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            AccountScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("Manage Address", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            AddressScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("Contact Us", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => ContactScreen(
                              user: widget.user,
                            )));
              },
            ),
            ListTile(
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextFormField(
                controller: _prnameController,
                decoration: InputDecoration(
                  hintText: "Search product",
                  suffixIcon: IconButton(
                    onPressed: () => _searchProduct(_prnameController.text),
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white24)),
                ),
              ),
            ),
            if (productlist.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: Center(
                      child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: (screenWidth / screenHeight) / 0.8,
                          children: List.generate(productlist.length, (index) {
                            return GestureDetector(
                              onTap: () => _descrip(index),
                              child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Card(
                                    elevation: 10,
                                    child: SingleChildScrollView(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: screenHeight / 4.5,
                                          width: screenWidth / 1,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://javathree99.com/s269426/constructorequipment/images/product/${productlist[index]['prid']}.jpg",
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                "" +
                                                    productlist[index]
                                                        ['prname'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(height: 2),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                "Type: " +
                                                    productlist[index]
                                                        ['prtype'],
                                                style:
                                                    TextStyle(fontSize: 14))),
                                        SizedBox(height: 2),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                "Price:RM " +
                                                    productlist[index]
                                                        ['prprice'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        Colors.red.shade900))),
                                      ],
                                    )),
                                  )),
                            );
                          })))),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_cart),
          backgroundColor: Colors.red[900],
          onPressed: _cart),
    );
  }

  void _loadProduct() {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadproduct.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        var jsondata = json.decode(response.body);
        productlist = jsondata["products"];
        setState(() {
          print(productlist);
        });
      }
    });
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  _searchProduct(String prname) {
    print(prname);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadproduct.php"),
        body: {
          "productname": prname,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        setState(() {
          print(productlist);
          var jsondata = json.decode(response.body);
          productlist = jsondata["products"];
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  Future<void> _category(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('CATEGORY'),
              content: new Container(
                  height: screenHeight / 4.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("ALL"),
                          trailing: Radio(
                            activeColor: Colors.red.shade900,
                            value: 1,
                            groupValue: sortButton,
                            onChanged: (value) {
                              setState(() {
                                sortButton = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("SERVICES"),
                          trailing: Radio(
                            activeColor: Colors.red.shade900,
                            value: 2,
                            groupValue: sortButton,
                            onChanged: (value) {
                              setState(() {
                                sortButton = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("RENTING"),
                          trailing: Radio(
                            activeColor: Colors.red.shade900,
                            value: 3,
                            groupValue: sortButton,
                            onChanged: (value) {
                              setState(() {
                                sortButton = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("PRODUCTS"),
                          trailing: Radio(
                            activeColor: Colors.red.shade900,
                            value: 4,
                            groupValue: sortButton,
                            onChanged: (value) {
                              setState(() {
                                sortButton = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )),
              actions: [
                TextButton(
                  child: (Text(
                    'OK',
                    style: TextStyle(fontSize: 14),
                  )),
                  onPressed: () {
                    _ok(sortButton);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: (Text('CANCEL')),
                  onPressed: () {
                    _cancel(sortButton);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  void _ok(int sortButton) {
    print(sortButton);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadproduct.php"),
        body: {
          "category": sortButton.toString(),
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        setState(() {
          print(productlist);
          var jsondata = json.decode(response.body);
          productlist = jsondata["products"];
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  void _cancel(int sortButton) {}

  void _descrip(index) {
    Product product = new Product(
      prid: productlist[index]['prid'],
      prname: productlist[index]['prname'],
      prtype: productlist[index]['prtype'],
      prprice: productlist[index]['prprice'],
      description: productlist[index]['description'],
      prqty: productlist[index]['prqty'],
    );
    if (productlist[index]['prtype'] == 'Product') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => ProductScreen(
                    product: product,
                    user: widget.user,
                  )));
    } else if (productlist[index]['prtype'] == 'Renting') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) =>
                  RentingProduct(product: product, user: widget.user)));
    } else if (productlist[index]['prtype'] == 'Services') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) =>
                  ServicesProduct(product: product, user: widget.user)));
    }
  }

  _cart() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => CartScreen(user: widget.user)));
  }
}
