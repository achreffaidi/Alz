import 'dart:convert';

import 'package:alz/Api/memories.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:alz/Constant/images.dart';
import 'package:alz/Game/DoubleChoiceGame/DoubleChoiceGame.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'Contact/ContactUI.dart';
import 'Emergency/Emergency.dart';
import 'Face/FaceReco.dart';
import 'LiveFaceDetect/FaceDetect.dart';
import 'Memories/MemoryDetails.dart';
import 'MemoryGame/MemoryGame.dart';
import 'Settings/SettingsUI.dart';
import 'Storage/Storage.dart';
import 'Tasks/tasksUI.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {






  List<ImageProvider> images = new List();
  Memories memories ;

  double headerSize = 200 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: c1,
        child:  Column(
          children: <Widget>[
            _getHeader(),
            _getBody()
          ],
        ),
      ) ,
    );
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
        margin: EdgeInsets.only(top: 40),
          height: MediaQuery.of(context).size.height-headerSize-40,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getCarsoulet(),
                getMenu(500)
                ,Container(height: 200,)
              ],),
          )
      ),
    );
  }

  Widget _getHeader(){
    return GestureDetector(
      child: Container(
        height: headerSize,
        child: Center(child: Text("Hello\nMr. Ben",style: TextStyle(fontSize: 40 , color: Colors.white , fontWeight: FontWeight.bold),textAlign: TextAlign.center, )),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsUI()),
        );

      },
    );
  }




  Widget getBody(){

    return SingleChildScrollView(
      child: Container(
          child : Column(
            children: <Widget>[
             // getMemories() ,
              getMenu(400)
            ],
          )
      ) ,
    );


  }



  Widget getMemories(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(child: Text("Memories",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.grey),),),
         getCarsoulet(),
        ],
      ),
    );

  }




  Widget getMenu(double height){

    return Container(
      margin: EdgeInsets.symmetric(vertical: 30 ),
      child: Column(
        children: <Widget>[
      GestureDetector(child:  getMenuItem(Image.asset("assets/face.png",fit: BoxFit.fill,), height/3) , onTap: (){


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FaceDetect()),
      ).then((value){
        setState(() {

        });
      });
      },),
          GestureDetector(child:  getMenuItem(Image.asset("assets/tasks.png",fit: BoxFit.fill,), height/3) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TasksUI()),
            );
          },),
          GestureDetector(child: Container( child: getMenuItem(Image.asset("assets/storage.png",fit: BoxFit.fill,), height/3)) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
            );
          },),
          GestureDetector(child: Container(child: getMenuItem(Image.asset("assets/contacts.png",fit: BoxFit.fill,), height/3)) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactUI()),
            );
          },),
          GestureDetector(child: Container(child: getMenuItem(Image.asset("assets/emergency.png",fit: BoxFit.fill,), height/3)) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Emergency()),
            );

          },),



        ],
      ),
    ) ;
  }
  Widget getMenuItem(image , height ){

    return

      Padding(
        padding: const EdgeInsets.only(top : 20.0 ),
        child: Container(
          width: 600,
          decoration: new BoxDecoration(

            borderRadius: new BorderRadius.all(
                Radius.circular(20.0)
            )
            ,
           ),
          height: height*0.7,
          child: Container(
            child: image,
          ),
        ),
      );

  }

  void loadPicture() async {

    print("loading pictures ") ;
    await http.get(baseUrl+"memories").then((http.Response response){
      print(response.statusCode) ;
      memories = Memories.fromJson(response.body);
      images = new List();
      for(Picture picture in memories.pictures){
        images.add(Image.network(picture.pictureUrl).image);
      }
      setState(() {

      });
    });
  }
  Widget getCarsoulet(){
    return images.isEmpty?Container():Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      height: 300,

      child: Carousel(
        dotColor: c2,
        radius: Radius.circular(60),
        borderRadius: true,
        images: images,
        onImageTap: (index){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MemoryDetail(memories.pictures[index])),
          );
        },
      ),
    );
  }
  @override
  void initState() {
    loadPicture();
    sendLocation();
  }



  void sendLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var data = {
      "longitude" : position.longitude.toString() ,
    "latitude" : position.latitude.toString()
    } ;
    print("sending location ") ;
    http.post(baseUrl+"location", body: jsonEncode(data), headers: {
      "Content-Type":"application/json"
    }).then((http.Response response){
    print(json.encode(data) +"sending Location Code " + response.statusCode.toString()) ;
    });
  }

}
