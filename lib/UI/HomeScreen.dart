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
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _textSizeValue = 20;
  List<ImageProvider> images = new List();
  Memories memories;

  double headerSize = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
                "assets/background1.png",
              ).image,
              fit: BoxFit.fill),
        ),
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Container(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: getMemories()),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: getPanel())
              ],
            ),
          )),
    );
  }

  Widget _getHeader() {
    return GestureDetector(
      child: Container(
        height: headerSize,
        child: Center(
            child: Text(
          "Hello\nMr. Ben",
          style: TextStyle(
              fontSize: _textSizeValue + 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsUI()),
        ).then(_loadTextSize());
      },
    );
  }

  Widget getPanel() {
    var h = 340.0;
    var w = 270.0;
    var d = 220.0;
    var lableStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: _textSizeValue + 20);
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 25.0, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TasksUI()),
                          ).then((value) {
                            setState(() {});
                          });
                        } , child :Container(
                      color: Colors.transparent,

                      width: w,
                      height: h,
                      child: Center(
                          child: Text(
                        "Tasks",
                        style: lableStyle,
                      )),
                    )),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
                          ).then((value) {
                            setState(() {});
                          });
                        } , child :Container(
                      color: Colors.transparent,

                      width: w,
                      height: h,
                      child: Center(child: Text("Game", style: lableStyle)),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FaceDetect()),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        color: Colors.transparent,

                        width: w,
                        height: h,
                        child: Center(child: Text("Faces", style: lableStyle)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUI()),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: w,
                        height: h,
                        child: Center(child: Text("Contacts", style: lableStyle)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Emergency()),
                    ).then((value) {
                      setState(() {});
                    });
                  } , child :Container(

                height: d,
                width: d,
                decoration: BoxDecoration(
                    color: Colors.transparent,

                    shape: BoxShape.circle),
                child: Center(child: Text("HELP", style: lableStyle)),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        children: <Widget>[
          // getMemories() ,
          getMenu()
        ],
      )),
    );
  }

  Widget getMemories() {
    return images.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: 20, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: getCarsoulet()),
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(memories.pictures[currentImage].title,
                            style: TextStyle(
                                fontSize: _textSizeValue + 25,
                                fontWeight: FontWeight.bold,
                                color: c1)),
                      )),
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(memories.pictures[currentImage].description,
                            style: TextStyle(fontSize: _textSizeValue + 10)),
                      )),
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(memories.pictures[currentImage].date,
                            style: TextStyle(
                                fontSize: _textSizeValue + 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget getMenu() {
    return Container(
      width: MediaQuery.of(context).size.height / 2.2,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: getMenuItem(Image.asset(
              "assets/face.png",
              fit: BoxFit.fill,
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaceDetect()),
              ).then((value) {
                setState(() {});
              });
            },
          ),
          GestureDetector(
            child: getMenuItem(Image.asset(
              "assets/tasks.png",
              fit: BoxFit.fill,
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksUI()),
              );
            },
          ),
          GestureDetector(
            child: Container(
                child: getMenuItem(Image.asset(
              "assets/storage.png",
              fit: BoxFit.fill,
            ))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
              );
            },
          ),
          GestureDetector(
            child: Container(
                child: getMenuItem(Image.asset(
              "assets/contacts.png",
              fit: BoxFit.fill,
            ))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUI()),
              );
            },
          ),
          GestureDetector(
            child: Container(
                child: getMenuItem(Image.asset(
              "assets/emergency.png",
              fit: BoxFit.fill,
            ))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emergency()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getMenuItem(image) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: 600,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Container(
          child: image,
        ),
      ),
    );
  }

  int currentImage = 0;

  void loadPicture() async {
    print("loading pictures ");
    await http.get(baseUrl + "memories").then((http.Response response) {
      print(response.statusCode);
      memories = Memories.fromJson(response.body);
      images = new List();
      for (Picture picture in memories.pictures) {
        images.add(Image.network(picture.pictureUrl).image);
      }
      setState(() {});
    });
  }

  Widget getCarsoulet() {
    return images.isEmpty
        ? Container()
        : Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Carousel(
              dotColor: c2,
              autoplayDuration: Duration(seconds: 5),
              radius: Radius.circular(40),
              borderRadius: true,
              images: images,
              onImageChange: (a, b) {
                currentImage = b;
                setState(() {});
              },
              onImageTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MemoryDetail(memories.pictures[index])),
                );
              },
            ),
          );
  }

  @override
  void initState() {
    loadPicture();
    sendLocation();
    _loadTextSize();
  }

  void sendLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var data = {
      "lang": position.longitude.toString(),
      "lat": position.latitude.toString()
    };
    print("sending location ");
    http
        .get(baseUrl + "setPosition", headers: data)
        .then((http.Response response) {});
  }

  dynamic _loadTextSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = (prefs.getDouble("textSize") ?? 20);
    print("loaded value = " + _textSizeValue.toString());
    setState(() {});
  }
}
