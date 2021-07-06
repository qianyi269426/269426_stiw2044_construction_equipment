import 'package:construction_equipment/addressscreen.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  final User user;

  const AddAddress({Key key, this.user}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _detailedAdd = new TextEditingController();
  TextEditingController _area = new TextEditingController();
  TextEditingController _poscode = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(6.4502, 100.4959), zoom: 11.5);
  GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                height: 140,
                width: 320,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                )),
            Container(
              height: 280,
              width: 320,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ListView(scrollDirection: Axis.vertical, children: [
                TextField(
                  controller: _name,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      icon: Icon(Icons.account_circle,
                          color: Colors.red.shade900)),
                ),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      icon: Icon(Icons.phone_android_rounded,
                          color: Colors.red.shade900)),
                ),
                TextField(
                  controller: _detailedAdd,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Detailed Address',
                      icon: Icon(Icons.home_work, color: Colors.red.shade900)),
                ),
                TextField(
                  controller: _poscode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Poscode',
                      icon: Icon(Icons.location_city_outlined,
                          color: Colors.red.shade900)),
                ),
                TextField(
                  controller: _area,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Area',
                      icon: Icon(Icons.person_pin_circle_sharp,
                          color: Colors.red.shade900)),
                ),
                TextField(
                  controller: _state,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'State',
                      icon:
                          Icon(Icons.location_on, color: Colors.red.shade900)),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _done();
                      },
                      child: Text("Done",
                          style:
                              TextStyle(fontSize: 16, color: Colors.blue[600])),
                    ),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _done() {
    String name = _name.text.toString();
    String phoneno = _phone.text.toString();
    String detailedAdd = _detailedAdd.text.toString();
    String area = _area.text.toString();
    String poscode = _poscode.text.toString();
    String state = _state.text.toString();

    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/add_address.php"),
        body: {
          "email": widget.user.user_email,
          "name": name,
          "phoneno": phoneno,
          "detailedAddress": detailedAdd,
          "poscode": poscode,
          "area": area,
          "state": state,
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
            msg: "Added!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // _loadCart();
      }
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (content) => AddressScreen(
                  user: widget.user,
                )));
  }
}
