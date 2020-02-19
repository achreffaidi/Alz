import 'package:alz/Api/tasks.dart';
import 'package:alz/Api/tasksByDay.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
            image: AssetImage("assets/Group 14.png"),
            fit: BoxFit.cover,
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

        height: MediaQuery.of(context).size.height-120,
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
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
      Center(child: Text("Tasks",style: TextStyle(fontSize: _textSizeValue+10 , color: Colors.white , fontWeight: FontWeight.bold), )),
        Center(child: Text(formatted,style: TextStyle(fontSize: _textSizeValue+10 , color: Colors.white , fontWeight: FontWeight.bold), )),

      ],
      )
    );
  }

  
  Widget getList(){
    return tasks==null?Container():Container(
      height:MediaQuery.of(context).size.height-120 ,
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
        child : new ListView.builder
          (
            itemCount: tasks.length,
            scrollDirection: Axis.vertical,

            
            itemBuilder: (BuildContext ctxt, int index) {
              return  GestureDetector(
                onTap: (){

                    if(tasks[index].done){
                      setUnDone(tasks.elementAt(index).id.toString());
                    }else
                      setDone(tasks.elementAt(index).id.toString());
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
    height: 200,
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30))
    ),
    child: Row(

      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            if(x==0)
              x=50;
            else
              x=0;
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
                  child: Icon(Icons.check,color: c1,size: x,)
              )
          ),
        )),
        Container(
          width: 100,
          child: Center(child:Text(task.time,style: TextStyle(fontSize:_textSizeValue,))),
        ),
      Container(
       width: 800,
  child: Center(child:Text(task.title,style: TextStyle(fontSize:_textSizeValue+10,fontWeight: FontWeight.bold))),
  ),
        Container(

          child: task.imageUrl!=null ?Image.network(task.imageUrl,width: 140,height: 200,):Container(),
        )

      ],

    ),
  );
}
  Widget getItem1(String name,String time , String desc , String img,bool isDone , isElevated){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:isElevated? 20 : 30),
      padding: EdgeInsets.all(10),
      child:
    Card(
elevation: isElevated?10:2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: c2,
                  width: 8,
                  height: 150,
                ),
                Checkbox(value: isDone,onChanged: (value){

                },) ,
                Text(time??"",style: TextStyle(color: Colors.grey ,fontSize: 20),),


              ],
            ) ,

          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Text(name,style: TextStyle(fontSize: _textSizeValue+5 ,decoration: isDone? TextDecoration.lineThrough : TextDecoration.none , color: isDone? Colors.grey: Colors.black ),),
              Text(time,style: TextStyle(color: Colors.grey ,fontSize: _textSizeValue+5),)

            ],
          ),
            Container(
                height: 200,
                width: 200,
                child: Image.network(img))
          ],),
      ),
    )
      ,);

  }

  void loadTask() async {
    print(baseUrl+"getbyday/"+DateTime.now().weekday.toString());
    http.get(baseUrl+"getByDay/"+(DateTime.now().weekday).toString()).then((http.Response response){

      tasks = tasksByDayFromJson(response.body).listByDay;
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
  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }

}
