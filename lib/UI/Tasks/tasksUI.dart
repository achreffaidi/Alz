import 'package:alz/Api/tasks.dart';
import 'package:alz/Api/tasksByDay.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class TasksUI extends StatefulWidget {
  @override
  _TasksUIState createState() => _TasksUIState();
}


class _TasksUIState extends State<TasksUI> {

  List<ListByDay> tasks ;


  int  getDone(){
    if(tasks==null)return 0 ;
     int count = 0 ;
     for(ListByDay task in tasks) if(!task.done)count++;
     return count  ;
  }
  @override
  void initState() {


    loadTask();

  }

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
        height: MediaQuery.of(context).size.height-200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

         Container(
           margin: EdgeInsets.only(left: 20 ,top: 60),
           child:  Text("Undone Tasks : "+getDone().toString()+(getDone()==0?"":" tasks"),style: TextStyle(fontSize: 30),),
         ),
          getList(),



        ],)
      ),
    );
  }

  Widget _getHeader(){
    var now = new DateTime.now();
    var formatter = new DateFormat('EEEE, d MMM y');
    String formatted = formatter.format(now);

    return Container(
      height: 200,
      child: Center(child: Text(formatted,style: TextStyle(fontSize: 30 , color: Colors.white , fontWeight: FontWeight.bold), )),
    );
  }

  
  Widget getList(){
    return tasks==null?Container():Container(
      height:MediaQuery.of(context).size.height-400 ,
        child : new ListView.builder
          (
            itemCount: tasks.length,

            itemBuilder: (BuildContext ctxt, int index) {
              return  GestureDetector(
                onTap: (){

                    if(tasks[index].done){
                      setUnDone(tasks.elementAt(index).id.toString());
                    }else
                      setDone(tasks.elementAt(index).id.toString());
                },
                child: getItem(tasks.elementAt(index).title ,tasks.elementAt(index).time, tasks.elementAt(index).done,index==0),
              );
            }

        )
    ) ;
  }


  Widget getItem(String name,String time,bool isDone , isElevated){
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal:isElevated? 20 : 30),
      child:
    Card(
elevation: isElevated?10:2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: c2,
              width: 3,
              height: 100,
            ) ,

          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(name,style: TextStyle(fontSize: 25 ,decoration: isDone? TextDecoration.lineThrough : TextDecoration.none , color: isDone? Colors.grey: Colors.black ),),
              Text(time,style: TextStyle(color: Colors.grey ,fontSize: 20),)
            ],
          ),
            Checkbox(value: isDone,onChanged: (value){

            },) ,
          ],),
      ),
    )
      ,);

  }

  void loadTask() async {
    print(baseUrl+"getbyday/"+DateTime.now().weekday.toString());
    http.get(baseUrl+"getbyday/"+(DateTime.now().weekday-1).toString()).then((http.Response response){

      tasks = TasksByDay.fromJson(response.body).listByDay;
      print(response.body) ;
      tasks.sort((ListByDay item1,ListByDay item2){
        if(item1.done==item2.done)return 0 ;
        if(item1.done&!item2.done)return 1 ;
        return -1 ;
      });
      setState(() {

      });
    });

  }

  void setDone(String id) async {
    http.get(baseUrl+"setdone/"+id).then((http.Response response){
      loadTask();
      print(response.statusCode);
    });


  }
  void setUnDone(String id) async {
    http.get(baseUrl+"setundone/"+id).then((http.Response response){
      loadTask();
      print(response.statusCode);
    });


  }


}
