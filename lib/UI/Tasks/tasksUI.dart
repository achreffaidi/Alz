import 'dart:convert';

import 'package:alz/Api/tasks.dart';
import 'package:alz/Api/tasksByDay.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';



class TasksUI extends StatefulWidget {
  @override
  _TasksUIState createState() => _TasksUIState();
}


class _TasksUIState extends State<TasksUI> {

  List<ListByDay> tasks ;
  double _textSizeValue = 20 ;
  double checkSize=0;

  int selectedItem = 1 ;

  //TODO  change this values  :

  //For Items
  double itemWidth ;
  final itemPadding = 30.0 ;
  final itemDefaultHeight = 250.0 ;
  final itemAdditionalHeight = 50.0 ;
  final _buttonTextStyle = TextStyle(fontSize: 22 , color: Colors.white);
  final _buttonIcon = Icon(Icons.check,size: 25,color: Colors.white,) ;

  //For <  and > buttons
  final _buttonWidth = 60.0 ;
  final _buttonRadius = 40.0  ;
  final _arrowSize = 50.0 ;

  //For the Animation
  final _curve = Curves.linear ;
  final animationDuration = 500 ;

  // Try different animations and choose the best one .



  //TODO ------------------------


  int  getDone(){
    if(tasks==null)return 0 ;
     int count = 0 ;
     for(ListByDay task in tasks) if(!task.done)count++;
     return count  ;
  }
  @override
  void initState() {

    loadTask();
    _loadTextSize();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = (MediaQuery.of(context).size.width -6*itemPadding -2*_buttonWidth )/3;

    return Scaffold(
      body: Container(

        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background3.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Widget>[

            Column(

              children: <Widget>[
               _getHeader(),
                Container(

                    child: getList())

              ],
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                  decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    bottomRight:  Radius.circular(_buttonRadius),
                    topRight:  Radius.circular(_buttonRadius),
                  )
                   ),
                        width: _buttonWidth,
                        height: MediaQuery.of(context).size.height/3,
                        child: Center(child: Icon(Icons.keyboard_arrow_left ,size: _arrowSize,),)),
                    onTap: _moveLeft,
                  ),
                  GestureDetector(
                    child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              bottomLeft:  Radius.circular(_buttonRadius),
                              topLeft:  Radius.circular(_buttonRadius),
                            )
                        ),
                        width: _buttonWidth,
                        height: MediaQuery.of(context).size.height/3,
                        child: Center(child: Icon(Icons.keyboard_arrow_right ,size: _arrowSize,),)),
                    onTap: _moveRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _getHeader(){
    var now = new DateTime.now();
    var formatter = new DateFormat('EEEE, d MMM y');
    String formatted = formatter.format(now);

    return Container(
      height: 155,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.arrow_back , size: 80, color: Colors.white,),
                )
            ),
            Container(
                child:Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
    Center(child: Text("Tasks",style: TextStyle(fontSize: _textSizeValue+20 , color: Colors.white , fontWeight: FontWeight.bold), )),
   // Center(child: Text(formatted,style: TextStyle(fontSize: _textSizeValue+15 , color: Colors.white , fontWeight: FontWeight.bold), )),

    ],
    )),
            SizedBox(width: 100,)
    ]
      ),

    );
  }

  ScrollController _controller;

  _scrollListener() {

   // print("Scr = "+_controller.offset.toString());
    setState(() {

    });

  }

  _moveLeft() {
    _controller.animateTo(_controller.offset - (itemWidth+2*itemPadding),
        curve: _curve, duration: Duration(milliseconds: animationDuration));
    selectedItem--;
    setState(() {

    });
  }
  _moveRight() {
    _controller.animateTo(_controller.offset + (itemWidth+2*itemPadding),
        curve: _curve, duration: Duration(milliseconds: animationDuration));
  }


  Widget getList(){
    return tasks==null?Container():Container(
       height: MediaQuery.of(context).size.height-200,
       margin: EdgeInsets.symmetric(horizontal: _buttonWidth),
       // padding: EdgeInsets.symmetric(vertical: 20),
        child : new ListView.builder
          (
            shrinkWrap: true,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,

            scrollDirection: Axis.horizontal,

            itemBuilder: (BuildContext ctxt, int index) {
              return  GestureDetector(
                onTap: (){

sayIt(tasks[index].title+" . "+tasks[index].description) ;


                },
                child: SizedBox(
                    height: 300,
                    child: getItem(index,0,0)),
              );
            }

        )
    ) ;
  }

Widget getItem(int index, double left , double right )
{
  double x= (_controller.offset-(index-1)*(itemWidth+2*itemPadding));
  x=x.abs();
  double fraction = 0 ;
  if(x<itemWidth+itemPadding) {
   fraction = ((itemWidth+itemPadding)-x) / (itemWidth+itemPadding);
  }
  print(fraction);

  ListByDay task = tasks[index] ;
  if(x*x<1) print(task.title);

  return Container(
    width: itemWidth,
    margin: EdgeInsets.only(top: 30, left:itemPadding +left ,right:itemPadding+right),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          height: itemDefaultHeight + itemAdditionalHeight*fraction,
          child: Column(
          mainAxisSize: MainAxisSize.min,

            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(

                child: Center(child:Text(task.title,style: TextStyle(fontSize:_textSizeValue+10,fontWeight: FontWeight.bold))),
              ),

              Container(

                child: Center(child:Text(task.time,style: TextStyle(fontSize:_textSizeValue,))),
              ),
              Container(

                child: task.imageUrl!=null ?ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(40)
                  ),
                  child: Image.network(task.imageUrl,height: 140,width: 140,),
                ):Container(),
              ),
              Opacity(
                opacity: fraction,
                child: Container(
                    height: 50*fraction,
                    child: RaisedButton.icon(color: Colors.greenAccent, icon : _buttonIcon ,onPressed: (){}, label: Container( width: itemWidth*0.6, child: Center(child: Text("Done" , style: _buttonTextStyle ))),)),
              )
              //TODO Remove the Comments here when the layout is ready !
              /*
              Container(
                  height: 90,


                  decoration: BoxDecoration(

                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  child:RaisedButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30),
                        side: BorderSide(color: Colors.white)

                    ),
                    //highlightColor: Colors.white,
                    onPressed:(){
                      task.done? setUnDone(task.id):setDone(task.id);
                      setState(() {

                      });
                    },
                    color: Colors.white,
                    child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: c1,style: BorderStyle.solid,width: 3)
                        ),
                        child: Center(
                            child: Icon(Icons.check,color: c1,size: task.done? 50:0,)
                        )
                    ),
                  )),
              */

            ],

          ),
        ),
      ],
    ),
  );
}













  void loadTask() async {
    print(baseUrl+"getbyday/"+DateTime.now().weekday.toString());
    http.get(baseUrl+"getByDay/"+(DateTime.now().weekday-1).toString()).then((http.Response response){

      tasks = tasksByDayFromJson(response.body).listByDay;

      //TODO : this is just for debugging , remove it once  the code is ready
      tasks = tasks+tasks ;

      print(response.body) ;
//      tasks.sort((ListByDay item1,ListByDay item2){
//        if(item1.done==item2.done)return 0 ;
//        if(item1.done&!item2.done)return 1 ;
//        return -1 ;
//      });
      setState(() {

      });
    });

  }

  void setDone(String id) async {
    http.get(baseUrl+"setDone/"+id).then((http.Response response){
      loadTask();
      print(response.statusCode);
    });


  }
  void setUnDone(String id) async {
    http.get(baseUrl+"setUndone/"+id).then((http.Response response){
      loadTask();
      print(response.statusCode);
    });


  }
  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

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

}
