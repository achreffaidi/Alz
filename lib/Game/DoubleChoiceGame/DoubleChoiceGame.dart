import 'dart:collection';
import 'dart:convert';

import 'package:alz/Api/ImagesLinks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../Constant/Strings.dart';
import '../../Constant/colors.dart';
import 'LettersTest.dart';
import 'Test.dart';
import 'package:alz/Api/GameCategories.dart';
import 'ColorsTest.dart';
import 'MathsTest.dart';
import 'AnimalsTest.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';




class DoubleChoiceGame extends StatefulWidget {
  @override
  _DoubleChoiceGameState createState() => _DoubleChoiceGameState();
}

class _DoubleChoiceGameState extends State<DoubleChoiceGame> {

  static const int STATE_LOADING = 0 ;
  static const int STATE_PLAYING = 1 ;
  int score = 0  ;
  int state = STATE_LOADING ;
  List<CategoriesList> categoriesList;
  List<String> labelsList=new List();

  List<Test> tests = new List() ;
  Random random ;

  Widget content = Container();
  double CardHeight;
  int current = 0;
  int correct = 0, wrong = 0;
  bool isPaying = false;

  double _textSizeValue = 20 ;

  @override
  void initState() {
    _loadTests();
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
                      tests = null ;
                      _loadTests();
                    });

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
                generateTest();
              },
            ),
          ),
        ),
      ),
    );
  }


  void _loadTests()  async {
    tests = new List();
   await  _loadGameCategory().then((list) async{
       categoriesList = list ;

       for(int i = 0  ; i<15 ; i++){

        await addTest(i % list.length);
       }



     });

  }


  Future<void> addTest(int r) async {

    switch(categoriesList[r].category) {
      case "animals":{
        labelsList=categoriesList[r].labels;
        int rand1,rand2;

        for(int i=0;i<15;i++){
          rand1=Random().nextInt(labelsList.length);
          rand2=Random().nextInt(labelsList.length);

            rand2=labelsList.length - rand1-1 ;
            String l1 = labelsList[rand1] ;
          String l2 = labelsList[rand2] ;

          loadImages(l1,l2).then((value){
            if(value!=null){
              tests.add(AnimalsTest(Random().nextInt(2)+1, l1, l2,value.link1,value.link2, context));
             // tests = shuffle(tests);
            }
          });


        }
      } break;
      case "maths":{
        labelsList=["+","-","*"];
        int rand1;


          rand1=Random().nextInt(labelsList.length);
          tests.add(MathsTest(Random().nextInt(2)+1, Random().nextInt(10)+1, labelsList[rand1], Random().nextInt(10)+1, context));

      } break;
      case "colors":{
        int rand1,rand2;
        labelsList=["red","blue","green","pink","black","white"];
        List<Color> colorLabels=[Colors.red,Colors.blue,Colors.green,Colors.pink,Colors.black,Colors.white];

          rand1=Random().nextInt(labelsList.length);
          rand2=Random().nextInt(labelsList.length);
          while(rand2 == rand1)
            rand2=Random().nextInt(labelsList.length);
          tests.add(ColorsTest(Random().nextInt(2)+1, labelsList[rand1], colorLabels[rand1], labelsList[rand2], colorLabels[rand2], context));

      } break;
      case "Letters":{

        int rand1,rand2;


          rand1=Random().nextInt(27);
          rand2=Random().nextInt(27);
          while(rand2 == rand1)
            rand2=Random().nextInt(27);
          tests.add(LettersTest(Random().nextInt(2)+1, String.fromCharCode(rand1+97), String.fromCharCode(rand2+97), context));

      } break;
    }
  }


  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

 void generateTest(){
       print("last : "+tests.length.toString()) ;
      Test x = tests.last ;
      sayIt(x.question);
      tests.removeLast() ;
      content = Container(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              margin: EdgeInsets.all(20),
              child: Text(x.question , style: TextStyle(fontWeight: FontWeight.bold, fontSize: _textSizeValue+10 , color: Colors.white),),) ,
            Container(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
width: 200,

                    child: GestureDetector(child:
                      x.getFirstChoice(),
                    onTap: (){
                      commitAnswer(x.correct==1) ;
                    },),
                  ) ,
                  Container(
width: 200,
                    child: GestureDetector(child:
                      x.getSecondChoice(),
                    onTap: (){
                      commitAnswer(x.correct==2) ;
                    },),
                  ),
                ],
              ),
            ) ,
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
    addTest(random.nextInt(categoriesList.length)) ;
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

  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }

  Future<List<CategoriesList>> _loadGameCategory() async{
    List<CategoriesList> liste;
    await http.get(baseUrl+"photosGame/getCategories").then((http.Response response){

      if(response.statusCode==200){

        GameCategories categories = GameCategories.fromJson(response.body);
        liste= categories.categoriesList;
        random = Random();
      }

    });
    return liste;
  }

  Future<Links> loadImages(String v1,String v2) async
  {
    ImagesLinks link;
    await http.get(baseUrl+"photosGame/game", headers: {
      "image1": v1,
      "image2": v2
    }).then((http.Response response){
      print("Loading Images : "+response.body);
      link= imagesLinksFromJson(response.body);
      if(response.statusCode==200){

      }});
    return (link==null)?null:link.links;
  }

}
