import 'dart:convert';
import 'dart:math';

import 'package:alz/Api/GameImage.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {

  double _textSizeValue = 20 ;
  Widget content = Container();
  double CardHeight;
  int current = 0;
  int correct = 0, wrong = 0;
  bool isPaying = false;

  void initState()
  {
    _loadTextSize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    CardHeight = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 50,
            ),
            getScoreBar(),
            getBody(),
            getFooter()
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: c2,
          child: content,
        ),
      ),
    );
  }

  Widget getScoreBar() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        color: c1,
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Correct",
                    style: TextStyle(
                        fontSize: _textSizeValue+5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(correct.toString(),
                      style: TextStyle(
                          fontSize: _textSizeValue+5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Wrong",
                      style: TextStyle(
                          fontSize: _textSizeValue+5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(wrong.toString(),
                      style: TextStyle(
                          fontSize: _textSizeValue+5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getFooter() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        color: c1,
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child:  Center(
            child: isPaying?  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  color: Colors.green,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: Container(
                      height: 80,
                      child: Center(
                          child: Text("RESET",
                              style: TextStyle(
                                  fontSize: _textSizeValue+5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  onPressed: () {
                    setState(() {
                      correct = 0;
                      wrong = 0;
                    });
                    fetchImages();
                  },
                ),
                RaisedButton.icon(
                  color: Colors.black,
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: Container(
                      height: 80,
                      child: Center(
                          child: Text("EXIT",
                              style: TextStyle(
                                  fontSize: _textSizeValue+5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ) :  RaisedButton.icon(
              color: Colors.green,
              icon: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 25,
              ),
              label: Container(
                  height: 80,
                  child: Center(
                      child: Text("  Start  ",
                          style: TextStyle(
                              fontSize: _textSizeValue+5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
              onPressed: () {
                setState(() {
                 isPaying = true ;
                });
                fetchImages();
              },
            ),
          ),
        ),
      ),
    );
  }

  void fetchImages() async {
    List list = List();
    list.addAll(dictionary);
    var rng = new Random();
    int i = rng.nextInt(list.length);
    String s1 = list[i];
    list.removeAt(i);
    String s2 = list[rng.nextInt(list.length)];

    print(s1);
    print(s2);
    var queryParameters = {
      'q': s1,
      'image_type': 'illustration',
      'key': '14616615-e1ccd2349de2a05236aded940',
      'page': '1',
      'per_page': '3',
    };

    String link1, link2;
    var uri = Uri.https("pixabay.com", "/api/", queryParameters);

    await http.get(uri).then((http.Response response) {
      GameImage image = GameImage.fromJson(response.body);
      link1 = image.hits[0].webformatUrl;
    });

    queryParameters = {
      'q': s2,
      'image_type': 'image',
      'key': '14616615-e1ccd2349de2a05236aded940',
      'page': '1',
      'per_page': '3',
    };
    uri = Uri.https("pixabay.com", "/api/", queryParameters);
    await http.get(uri).then((http.Response response) {
      GameImage image = GameImage.fromJson(response.body);
      link2 = image.hits[0].webformatUrl;
    });

    setState(() {
      content = getNextCard(s1, link1, s2, link2);
    });
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
      print("voice") ;
    });
    
  }
  AudioPlayer audioPlayer ;

  play(String url ) async {

    print(url);
    AudioPlayer.logEnabled = true;
    audioPlayer = AudioPlayer();

    int result = await audioPlayer.play(url);


    if (result == 1) {
      // success
    }
  }


  Widget getNextCard(s1, url1, s2, url2) {
    var rng = new Random();
    current = rng.nextInt(2);
    String name;
    if (current == 0) {
      name = s1;
    } else {
      name = s2;
    }
    sayIt(name);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
              fontSize: _textSizeValue+10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getImage(CardHeight * 0.7, url1, 0),
              getImage(CardHeight * 0.7, url2, 1),
            ],
          ),
        )
      ],
    );
  }

  Widget getImage(side, url, num) {
    return Container(
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        color: Colors.white,
        elevation: 5,
        onPressed: () {
          if (num == current) {
           correctAnswer() ;
          } else {

            wrongAnswer();
          }

        },
        child: SizedBox(
          height: side,
          width: side,
          child: Image.network(
            url,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void wrongAnswer() {
    setState(() {
      wrong++ ;
      content = Center(
          child: FlareActor(
        "assets/wrong.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Error",
      ));
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      fetchImages();
    });
  }
  void correctAnswer() {
    setState(() {
      correct++;
      content = Center(
          child: FlareActor(
            "assets/correct.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "run",
          ));
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      fetchImages();
    });
  }
  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }


}
