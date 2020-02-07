import 'dart:collection';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../Constant/Strings.dart';
import '../../Constant/colors.dart';
import 'LettersTest.dart';
import 'Test.dart';
import 'package:http/http.dart' as http;



class DoubleChoiceGame extends StatefulWidget {
  @override
  _DoubleChoiceGameState createState() => _DoubleChoiceGameState();
}

class _DoubleChoiceGameState extends State<DoubleChoiceGame> {

  static const int STATE_LOADING = 0 ;
  static const int STATE_PLAYING = 1 ;
  int score = 0  ;
  int state = STATE_LOADING ;


  List<Test> tests = new List() ;


  Widget content = Container();
  double CardHeight;
  int current = 0;
  int correct = 0, wrong = 0;
  bool isPaying = false;

  @override
  void initState() {
    _loadTests();
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
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(correct.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Wrong",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(wrong.toString(),
                      style: TextStyle(
                          fontSize: 25,
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
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  onPressed: () {
                    setState(() {
                      correct = 0;
                      wrong = 0;
                    });
                    generateTest();
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
                                  fontSize: 25,
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
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
              onPressed: () {
                setState(() {
                  isPaying = true ;
                });
                generateTest();
              },
            ),
          ),
        ),
      ),
    );
  }


  void _loadTests(){
    tests.add(LettersTest(1,"a","b",context)) ;
    tests.add(LettersTest(2,"c","d",context)) ;
    tests.add(LettersTest(1,"e","f",context)) ;
    tests.add(LettersTest(2,"h","g",context)) ;
    tests.add(LettersTest(1,"a","b",context)) ;
    tests.add(LettersTest(2,"c","d",context)) ;
    tests.add(LettersTest(1,"e","f",context)) ;
    tests.add(LettersTest(2,"h","g",context)) ;
    tests.add(LettersTest(1,"a","b",context)) ;
    tests.add(LettersTest(2,"c","d",context)) ;
    tests.add(LettersTest(1,"e","f",context)) ;
    tests.add(LettersTest(2,"h","g",context)) ;
  }

 void generateTest(){
      Test x = tests.last ;
      sayIt(x.question);
      tests.removeLast() ;
      content = Container(
        height: 500,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Text(x.question , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30 , color: Colors.white),),) ,
            GestureDetector(child:
              x.getFirstChoice(),
            onTap: (){
              commitAnswer(x.correct==1) ;
            },) ,
            GestureDetector(child:
              x.getSecondChoice(),
            onTap: (){
              commitAnswer(x.correct==2) ;
            },) ,
          ],
        ),

      );
      setState(() {

      });
 }


 void commitAnswer(bool correct){
    if(correct){
      this.correct++ ;
    }else{
      this.wrong++ ;
    }
    Toast.show(correct?"True":"False", context );
    generateTest();
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

}
