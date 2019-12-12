import 'package:alz/Constant/colors.dart';
import 'package:alz/Model/Stuff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Storage extends StatefulWidget {
  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {


  List<Stuff> list = new List() ;
  String pattern ="";
  @override
  void initState() {

    list.add(new Stuff("Medicaments", "In the medicine cabinet , in the bathroom", "https://www.containerstore.com/catalogimages/354039/HowToOrganizeYourMedicineCabinet_120.jpg?width=1200&height=1200&align=center")) ;
    list.add(new Stuff("Glasses", "In the night stand , in my bedroom", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJKIzoJLvYuV80gMUjpiiP_O11xASwMafY01i3JUP4XsZef5Be&s")) ;
    list.add(new Stuff("Clothes", "In my bedroom closet", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4lSA8Xpm0RKLpKzc7MuumgmMU4CubQG5XUx_TFlkuW3LWmlzE&s")) ;
  }



  List<String> getStuffNames(String name){
    List<String> l = new List() ;
    for(Stuff stuff in list){
      if(stuff.name.toLowerCase().startsWith(name.toLowerCase())){
        l.add(stuff.name);
      }
    }
    return l ;
  }

  List<Stuff> getStuff(){
    List<Stuff> l = new List() ;
    for(Stuff stuff in list){
      if(stuff.name.toLowerCase().startsWith(pattern)){
        l.add(stuff);
      }
    }
    return l ;
  }
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
              Container(

                margin: EdgeInsets.only(right: 20 , left: 20,top: 60),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      style: TextStyle(fontSize: 30),
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    return   getStuffNames(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(

                      title: Text(suggestion),

                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      pattern  = suggestion ;
                    });
                  },
                ),
              ),

              getList()

            ],)
      ),
    );
  }

  Widget _getHeader(){
    return Container(
      height: headerSize,
      child: Center(child: Text("Storage",style: TextStyle(fontSize: 30 , color: Colors.white , fontWeight: FontWeight.bold), )),
    );
  }

  Widget getList(){

    List<Stuff> myList = getStuff();
    return Container(
        height:MediaQuery.of(context).size.height-300 ,
        child : new ListView.builder
          (
            itemCount: myList.length,

            itemBuilder: (BuildContext ctxt, int index) {
              return   getItem(myList[index]) ;

            }

        )
    ) ;
  }


  Widget getItem(Stuff stuff){
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child:
      Card(
        elevation:2,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.purple,
                width: 3,
                height: 100,
              ) ,

              Container(
                width: 140,
                margin: EdgeInsets.all(10),
                child: Image.network(stuff.url),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(stuff.name , style: TextStyle(fontSize: 20),textWidthBasis: TextWidthBasis.parent,),
                    Text(stuff.position),
                  ],
                ),
              )

            ],),
        ),
      )
      ,);

  }


}
