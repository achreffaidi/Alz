import 'dart:convert';

import 'package:alz/Api/memories.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:alz/Constant/images.dart';
import 'package:alz/Game/DoubleChoiceGame/DoubleChoiceGame.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  double headerSize = 150;



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: c1,
      body: Container(
        padding: EdgeInsets.all(0),
//        decoration: BoxDecoration(
//          image: DecorationImage(
//              image: Image.asset(
//                "assets/mainScreenBackground.png",
//              ).image,
//              fit: BoxFit.fill),
//        ),
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getHeader(),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: getMemories()
                    ),
                    Container(
                      padding: EdgeInsets.only(top:20),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Emergency()),
                            ).then((value) {
                              setState(() {});
                            });
                          } , child :Container(
                        width: MediaQuery.of(context).size.width / 2 - 60,
                        height: 140,
                        decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 100,right: 100),
                              child: Image.asset("assets/helpIconNew.png",width: 130,),
                            ),

                            Text("HELP", style: TextStyle(fontWeight: FontWeight.bold,fontSize: _textSizeValue+40,color: Colors.white)),


                          ],
                        )),
                      )),
                    ),

                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: getPanel3())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHeader() {
    return GestureDetector(
      child: Container(
          height: 143,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/homeIconNew.png",width: 100,height: 150,),
              Container(width: 70,),
              Center(

                  child: Text(
                    "Good evening Mrs.",
                    style: TextStyle(
                      fontSize: _textSizeValue + 40,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ],
          )
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsUI()),
        ).then(_loadTextSize());
      },
    );
  }

  Widget getPanel3()
  {
    double contSize=140;
    return Container(

      padding: EdgeInsets.only(left:20.0,right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksUI()),
              ).then((value) {
                setState(() {});
              });

            },
            child:Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(bottom: 10,top: 10),
              height: contSize,
              color: Colors.white,
              child:Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset("assets/taskIconNew.png",width: 200,),

                  SizedBox(
                    width: 480,
                    child: Center(child: Text('Tasks',style: TextStyle(fontWeight: FontWeight.bold,color: c3,fontSize: _textSizeValue+40,),textAlign: TextAlign.center,)),
                  ),


                ],
              ),
            ),
          )
          ,              GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaceDetect()),
              ).then((value) {
                setState(() {});
              });

            },
            child:  Container(
              margin: EdgeInsets.only(bottom: 20,top: 20),
              padding: EdgeInsets.only(bottom: 10,top: 10,),
              height: contSize,
              color: Colors.white,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset("assets/faceIconNew.png",width: 200,),
                  SizedBox(
                    width: 480,
                    child: Center(child: Text('Face',style: TextStyle(fontWeight: FontWeight.bold,color: c3,fontSize: _textSizeValue+40),textAlign: TextAlign.center)),
                  ),


                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
              ).then((value) {
                setState(() {});
              });

            },
            child:  Container(
              margin: EdgeInsets.only(bottom: 20,top: 20),
              padding: EdgeInsets.only(bottom: 10,top: 10,),
              height: contSize,
              color: Colors.white,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset("assets/gameIconNew.png",width: 200,),
                  SizedBox(
                    width: 480,
                    child: Center(child: Text('Game',style: TextStyle(fontWeight: FontWeight.bold,color: c3,fontSize: _textSizeValue+40),textAlign: TextAlign.center)),
                  ),


                ],
              ),
            ),
          ),  GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUI()),
              ).then((value) {
                setState(() {});
              });

            },
            child:  Container(
              margin: EdgeInsets.only(bottom: 20,top: 20),
              padding: EdgeInsets.only(bottom: 10,top: 10,),
              height: contSize,
              color: Colors.white,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset("assets/contactsIconNew.png",width: 200,),

                  SizedBox(width: 480,
                    child: Center(child: Text('Contacts',style: TextStyle(fontWeight: FontWeight.bold,color: c3,fontSize: _textSizeValue+40),textAlign: TextAlign.start)),
                  ),


                ],
              ),
            ),
          ),

        ],
      ),
    );

  }
  /*   OLD UI
  Widget getPanel2()
  {
    var h =MediaQuery.of(context).size.height - headerSize -100;
    var w = 320.0;
    var d = 220.0;
    return Container(
    margin: EdgeInsets.only(left: 35,top: 30,right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: w,
                height: h,

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FaceDetect()),
                    ).then((value) {
                      setState(() {});
                    });

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(topLeft:  Radius.circular(68)),

                    ),
                  ),
                ),
              ),
              SizedBox(width: 22,),
              Container(
                width: w+6,
                height: h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
                      ).then((value) {
                        setState(() {});
                      });
                    } ,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(64)),

                    ),
                    ),
              ),)
            ],
          ),
          SizedBox(height: 18,),
          Row(
            children: <Widget>[
              Container(
                width: w,
                height: h-15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksUI()),
                    ).then((value) {
                      setState(() {});
                    });
                  } ,
                  child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(71)),


             ),
              ),
                ),

              ),
              SizedBox(width: 22,),
              Container(
                width: w+6,
                height: h-15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUI()),
                    ).then((value) {

                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(bottomRight:  Radius.circular(66)),



                    ),
                  ),

                ),
              ),
            ],
          ),
          SizedBox(height: 28,),
          Container(
            height: 188,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Emergency()),
                  ).then((value) {
                    setState(() {});
                  });
                },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(  Radius.circular(35)),

                ),
              ),),
          )
        ],
      ),
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
padding: EdgeInsets.all(20),
                      width: w,
                      height: h,
                      child: Center(
                          child: Column(
mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                        "Tasks",
                        style: lableStyle,
                      ),
                            SizedBox(height: 15,),
                            Image.asset("assets/tasksIcon.png",width: 220) //Icon(Icons.format_list_bulleted,size: 100.0),
                            ],
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
                      padding: EdgeInsets.all(20),
                      width: w,
                      height: h,
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text("Game", style: lableStyle),
                          SizedBox(height: 15,),
                          Image.asset("assets/gameIcon.png",width: 178,)
                        ],
                      )),
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
                        padding: EdgeInsets.all(20),

                        width: w,
                        height: h,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(height: 30,),
                            Image.asset("assets/faceIcon.png",width: 200,),
                            SizedBox(height: 10,),
                            Text("Faces", style: lableStyle),

                          ],
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUI()),
                        ).then((value) {

                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(20),

                        width: w,
                        height: h,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(height: 50,),
                            Image.asset("assets/contactsIcon.png",width: 200,),
                            SizedBox(height: 10,),
                            Text("Contacts", style: lableStyle),
                          ],
                        )),
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
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("HELP", style: lableStyle),
                    Image.asset("assets/helpIcon.png",width: 130,),

                  ],
                )),
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
*/
  Widget getMemories() {
    return images.isEmpty
        ? Container()
        : Container(
      height: 500,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
//                    height: MediaQuery.of(context).size.height / 2,
              child: getCarsoulet()),
          Container(
//                  height: MediaQuery.of(context).size.height / 2 - 70,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(memories.pictures[currentImage].title,
                      style: TextStyle(
                          fontSize: _textSizeValue + 25,
                          fontWeight: FontWeight.bold,
                          color: c3)),
                )
            ),
//                  child: Column(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Container(
//                          child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Text(memories.pictures[currentImage].title,
//                            style: TextStyle(
//                                fontSize: _textSizeValue + 25,
//                                fontWeight: FontWeight.bold,
//                                color: c1)),
//                      )),
//                      Container(
//                          child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Text(memories.pictures[currentImage].description,
//                            style: TextStyle(fontSize: _textSizeValue + 10)),
//                      )),
//                      Container(
//                          child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Text(memories.pictures[currentImage].date,
//                            style: TextStyle(
//                                fontSize: _textSizeValue + 10,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.blueGrey)),
//                      )),
//                    ],
//                  ),
          ),
        ],
      ),
    );
  }
/*   OLD UI
  Widget getMenu() {
    return Container(
      width: MediaQuery.of(context).size.height / 2.2,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[

      GestureDetector(child:  getMenuItem(Image.asset("assets/face.png",fit: BoxFit.fill,)) , onTap: (){


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FaceDetect()),
      ).then((value){
        setState(() {

        });
      });
      },),
          GestureDetector(child:  getMenuItem(Image.asset("assets/tasks.png",fit: BoxFit.fill,)) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TasksUI()),
            );
          },),
          GestureDetector(child: Container( child: getMenuItem(Image.asset("assets/storage.png",fit: BoxFit.fill,))) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoubleChoiceGame()),
            );
          },),
          GestureDetector(child: Container(child: getMenuItem(Image.asset("assets/contacts.png",fit: BoxFit.fill,))) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactUI()),
            );
          },),
         /* GestureDetector(child: Container(child: getMenuItem(Image.asset("assets/emergency.png",fit: BoxFit.fill,))) , onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Emergency()),
            );

          },),*/




        ],
      ),
    );
  }
*/
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
        :  Container(

        margin: EdgeInsets.only(left: 15 , right : 15 , top : 30,bottom: 20),
        child  :
        new CarouselSlider.builder(


          onPageChanged: (val){
            currentImage = val;
            setState(() {});
            sayIt(memories.pictures[currentImage].description);
          },
          enableInfiniteScroll: true,

          itemCount: memories.pictures.length,
          enlargeCenterPage: true,
          itemBuilder: (BuildContext context, int itemIndex) =>
              Container(

                  child: _getPicture(memories.pictures[itemIndex].pictureUrl)),
        ));

    /*
    autoPlay = false;



     */



  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    loadPicture();
    sendLocation();
    _loadTextSize();
    AudioPlayer.logEnabled = true;
    audioPlayer = AudioPlayer();

    audioPlayer.onPlayerCompletion.listen((object){



    });

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


  void sayIt(String s)async{
    var params = {
      "text": s,
    };

    http.post(baseUrl+"speech" ,body: json.encode(params) , headers: {
      "Content-Type":"application/json"
    }).then((http.Response response){

      print(response.statusCode);
      print(response.headers);
      if(response.headers.containsKey("voice")) play(response.headers["voice"]) ;

    });

  }
  AudioPlayer audioPlayer ;

  play(String url ) async {

    print(url);


    int result = await audioPlayer.play(url);


    if (result == 1) {
      // success
    }
  }

  Widget _getPicture(String pictureUrl) {

    return Container(

      margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(
          Radius.circular(20.0),

        )
        ,
        boxShadow: [
          new BoxShadow(
            color: c1,
            blurRadius: 2,
            spreadRadius:0.2,
            offset: new Offset(0, 0),
          )
        ],),
      child:Container(

        decoration: new BoxDecoration(
            image: DecorationImage(image: Image.network(pictureUrl,fit: BoxFit.cover,).image,fit: BoxFit.cover),
            borderRadius: new BorderRadius.all(
                Radius.circular(20.0)
            )
        ),
        child: Container(

        ),
      ),
    );

  }



}
