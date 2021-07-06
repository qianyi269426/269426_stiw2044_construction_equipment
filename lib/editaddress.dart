import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';

class EditAddress extends StatefulWidget {
  final User user;
  
  const EditAddress({ Key key, this.user }) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT ADDRESS'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      TextField(
                        //  controller: _name,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.account_circle,
                                color: Colors.red.shade900)),
                      ),
                      TextField(
                        //  controller: _phone,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            icon: Icon(Icons.phone_android_rounded,
                                color: Colors.red.shade900)),
                      ),
                      TextField(
                        //  controller: _state,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Detailed Address',
                            icon: Icon(Icons.location_on,
                                color: Colors.red.shade900)),
                      ),
                      TextField(
                        //  controller: _area,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Area',
                            icon: Icon(Icons.location_city_outlined,
                                color: Colors.red.shade900)),
                      ),
                      TextField(
                        //  controller: _poscode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Poscode',
                            icon: Icon(Icons.person_pin_circle_sharp,
                                color: Colors.red.shade900)),
                      ),
                      TextField(
                        //  controller: _detailedAdd,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'State',
                            icon: Icon(Icons.home_work,
                                color: Colors.red.shade900)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minWidth: 100,
                            height: 40,
                            onPressed: () {
                              _save();
                            },
                            child: Text("Save",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue[600])),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minWidth: 100,
                            height: 40,
                            onPressed: () {
                              _delete();
                            },
                            child: Text("Delete",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.red)),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _save() {}

  void _delete() {}
}