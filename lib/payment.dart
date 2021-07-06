import 'dart:async';

import 'package:construction_equipment/model/address.dart';
import 'package:construction_equipment/model/pay.dart';
import 'package:construction_equipment/model/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  final User user;
  final Address address;
  final Pay pay;
  
  const Payment({ Key key, this.user, this.address, this.pay }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAYMENT'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(child: WebView(
                initialUrl: 
                'https://javathree99.com/s269426/constructorequipment/php/generate_bill.php?email='+
                widget.user.user_email+
                '&phoneno='+
                widget.address.phoneno+
                '&name='+
                widget.address.name+
                '&address='+
                widget.address.detailed_address+" "+widget.address.poscode+" "+widget.address.area+" "+widget.address.state+
                '&addmessage='+
                widget.pay.addmessage+
                // '&delivery_time='+
                // widget.pay.delivery_time+
                '&totalprice='+
                widget.pay.totalprice.toString()
                ,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  _controller.complete(webViewController);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}