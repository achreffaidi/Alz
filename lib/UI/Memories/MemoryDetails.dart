import 'package:alz/Api/memories.dart';
import 'package:alz/Constant/colors.dart';
import 'package:flutter/material.dart';

class MemoryDetail extends StatefulWidget {

  Picture picture ;


  MemoryDetail(this.picture);

  @override
  _MemoryDetailState createState() => _MemoryDetailState();
}

class _MemoryDetailState extends State<MemoryDetail> {
  double headerSize = 100 ;

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
          height: MediaQuery.of(context).size.height-headerSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Column(
                children: <Widget>[
                  getImage(widget.picture.pictureUrl),
                  getTitle(widget.picture.title),
                  getDiscription(widget.picture.description),
                  getDate(widget.picture.date)
                ],
              ),

            ],)
      ),
    );
  }

  Widget _getHeader(){
    return Container(
      height: headerSize,
      child: Center(child: Text("Memory Details",style: TextStyle(fontSize: 30 , color: Colors.white , fontWeight: FontWeight.bold), )),
    );
  }

  Widget getDiscription(desc){

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50),
    child: Text(desc ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
  );
  }

  Widget getTitle(title){

  return Container(
    margin: EdgeInsets.only(top: 20 , bottom: 30),
    child: Text(title,style: TextStyle(fontSize: 30 , color: c2 , fontWeight: FontWeight.bold)),
  );
  }

  Widget getDate(date){

  return Container(
    margin: EdgeInsets.only(top: 50),
    child: Text(date,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
  );
  }

  Widget getImage(url){
    return Hero(
      tag: widget.picture.pictureId,
      child: Container(
        margin: EdgeInsets.only(top: 40),

          padding: EdgeInsets.symmetric(horizontal: 10),
          child : new ClipRRect(
            borderRadius: new BorderRadius.circular(60.0),
            child: Image.network(
              url,
              height: 300.0,

            ),
          )
      ),
    ) ;

  }
}
