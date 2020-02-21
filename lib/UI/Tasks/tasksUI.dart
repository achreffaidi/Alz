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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background3.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
           _getHeader(),
            _getBody()
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    return Container(

        height: MediaQuery.of(context).size.height-155,
          child: getList(),
    );
//         Container(
//           margin: EdgeInsets.only(left: 20 ,top: 60),
//           child:  Text("Undone Tasks : "+getDone().toString()+(getDone()==0?"":" tasks"),style: TextStyle(fontSize: _textSizeValue+10),),
//         ),
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
    Center(child: Text(formatted,style: TextStyle(fontSize: _textSizeValue+15 , color: Colors.white , fontWeight: FontWeight.bold), )),

    ],
    )),
            SizedBox(width: 100,)
    ]
      ),

    );
  }

  
  Widget getList(){
    return tasks==null?Container():Container(
      height:MediaQuery.of(context).size.height-200 ,
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
        child : new ListView.builder
          (
            itemCount: tasks.length,
            scrollDirection: Axis.vertical,

            
            itemBuilder: (BuildContext ctxt, int index) {
              return  GestureDetector(
                onTap: (){

sayIt(tasks[index].title+" . "+tasks[index].description) ;


                },
                child: getItem(tasks.elementAt(index)),
              );
            }

        )
    ) ;
  }

Widget getItem(ListByDay task)
{
  double x=50;
  return Container(
    margin: EdgeInsets.only(top: 30,right: 15,left: 15,bottom: 15),
    height: 180,
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30))
    ),
    child: Row(

      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
        Container(
          width: 180,
          child: Center(child:Text(task.time,style: TextStyle(fontSize:_textSizeValue,))),
        ),
      Container(
       width: 850,
  child: Center(child:Text(task.title,style: TextStyle(fontSize:_textSizeValue+10,fontWeight: FontWeight.bold))),
  ),
        Container(
          height: 140,
          width: 140,
          child: task.imageUrl!=null ?ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(40)
            ),
            child: Image.network(task.imageUrl,height: 140,width: 140,),
          ):Container(),
        )

      ],

    ),
  );
}

  void loadTask() async {
    print(baseUrl+"getbyday/"+DateTime.now().weekday.toString());
    http.get(baseUrl+"getByDay/"+(DateTime.now().weekday-1).toString()).then((http.Response response){

      tasks = tasksByDayFromJson(response.body).listByDay;
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
