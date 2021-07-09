import 'dart:io';

import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

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
  double screenHeight;
  double screenWidth;
  File _image;
  String pathAsset = 'assets/images/profile.png';

  @override
  void initState() {
    super.initState();
    _username.text = widget.user.username;
    _phoneno.text = widget.user.phoneno;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('ACCOUNT'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => {_onPictureSelectionDialog()},
                      child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.scaleDown,
                            ),
                          )),
                    ),
                    SizedBox(height: 5),
                    // Text(
                    //   'Click the camera to add photo',
                    //   style: TextStyle(fontSize: 10),
                    // ),
                    SizedBox(height: 10),

                    Card(
                      shadowColor: Colors.red.shade900,
                      elevation: 10,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 20, 5),
                            child: Text(
                              'Email: ' + widget.user.user_email,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 50,
                                    child: TextField(
                                      controller: _username,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: 'Username: ',
                                          enabled: _isEnable,
                                          icon: Icon(Icons.account_circle,
                                              color: Colors.red.shade900)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: IconButton(
                                        alignment: Alignment.topRight,
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            _isEnable = true;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 50,
                                    child: TextField(
                                      controller: _phoneno,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: 'Phone Number: ',
                                          enabled: _isEnable,
                                          icon: Icon(
                                              Icons.phone_android_rounded,
                                              color: Colors.red.shade900)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: IconButton(
                                        alignment: Alignment.topRight,
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            _isEnable = true;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            _done();
                          },
                          child: Text('Done')),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _done() {
    String username = _username.text.toString();
    String phoneno = _phoneno.text.toString();
    print(username);
    print(phoneno);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/account.php"),
        body: {
          "user_email": widget.user.user_email,
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
        setState(() {
          widget.user.username = _username.text.toString();
          widget.user.phoneno = _phoneno.text.toString();
        });
      }
    });
  }

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: new Container(
            height: screenHeight / 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Add photo from ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 100,
                      height: 100,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                      elevation: 10,
                      onPressed: () =>
                          {Navigator.pop(context), _camera(), _cropImage()},
                    )),
                    SizedBox(width: 10),
                    Flexible(
                        child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 100,
                      height: 100,
                      child: Text(
                        'Album',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                      elevation: 10,
                      onPressed: () => {Navigator.pop(context), _album()},
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    _cropImage();
  }

  _album() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    _cropImage();
  }

  _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
