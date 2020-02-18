import 'dart:convert';

import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {

  double _textSizeValue = 20 ;
  double headerSize = 100 ;
  String messageLost = "Hello , It's Me Ben , I am lost !";
  String messagePain = "Hello , It's Me Ben , I feed Pain !";
  String messageHelp = "Hello , It's Me Ben , I need Help !";
  List<String> recipents  = new List();


  @override
  void initState() {
    _loadEmergencyNumber() ;
    super.initState();
  }

  void initState(){
    _loadTextSize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: c1
        ,
        child:  Column(
          children: <Widget>[
            _getHeader(),
            _getBody()
          ],
        ),
      ) ,
    );
  }


  void _loadEmergencyNumber() async {

    http.get(baseUrl+"getEmergencyNumber").then((http.Response response){

      var parsedJson = json.decode(response.body);
      recipents.add(parsedJson["number"] ) ;


    });

  }

  Widget _getBody() {
    return Container(


      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
            topLeft:   Radius.circular(70.0)

        )
        ,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius:0.2,
            offset: new Offset(-3, -2.0),
          )
        ],),
      child: Container(
          height: MediaQuery.of(context).size.height-headerSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              getMenu(500)

            ],)
      ),
    );
  }

  Widget _getHeader(){
    return Container(
      height: headerSize,
      child: Center(child: Text("Emergency",style: TextStyle(fontSize: _textSizeValue+10 , color: Colors.white , fontWeight: FontWeight.bold), )),
    );
  }

  Widget getMenu(double height){

    return Container(

      margin: EdgeInsets.symmetric(vertical: 30 , horizontal: 20),
      child: Column(
        children: <Widget>[
          GestureDetector(child: Hero(tag :"screen2" ,child: getMenuItem(Image.asset("assets/help.png",fit: BoxFit.fill,) , height/3)) , onTap: (){
          _sendSMS(messageHelp, recipents) ;
          },),
          GestureDetector(child: Container( child: getMenuItem(Image.asset("assets/lost.png",fit: BoxFit.fill), height/3)) , onTap: (){
            _sendSMS(messageLost, recipents) ;
          },),
          GestureDetector(child: Container(child: getMenuItem(Image.asset("assets/pain.png",fit: BoxFit.fill), height/3)) , onTap: (){
            _sendSMS(messagePain, recipents) ;

          },),

        ],
      ),
    ) ;
  }
  Widget getMenuItem(image , height ){

    return

      Padding(
        padding: const EdgeInsets.only(top : 80.0 , right: 20 , left: 20),
        child: Container(
          decoration: new BoxDecoration(
           
            borderRadius: new BorderRadius.all(
                Radius.circular(20.0)
            )
            ,
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius:0.2,
                offset: new Offset(-3, -2.0),
              )
            ],),
          height: height*0.7,
          child: Container(
            child: image,
          ),
        ),
      );

  }

  void _sendSMS(String message, List<String> recipents) async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String messageToSend = message + "https://www.google.com/maps/search/?api=1&query="+position.latitude.toString()+","+ position.longitude.toString();
    String _result = await FlutterSms
        .sendSMS(message: messageToSend, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }

}
