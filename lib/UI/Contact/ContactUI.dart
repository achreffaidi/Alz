import 'package:alz/Constant/colors.dart';
import 'package:alz/Model/Contact.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContactUI extends StatefulWidget {
  @override
  _ContactUIState createState() => _ContactUIState();
}






class _ContactUIState extends State<ContactUI> {

  double headerSize = 100 ;
  double _textSizeValue = 20 ;

  List<TimelineModel> items = [
  ];
  @override
  void initState() {
    _loadTextSize();
    List<Contact> list = new List();
    list.add(new Contact("Marshall Melany", "52005985", "Daughter", "https://reductress.com/wp-content/uploads/2016/10/woman-outside-serious-820x500.jpg")) ;
    list.add(new Contact("Marshall John", "52005985", "Son", "https://www.schwarzkopf.fr/content/dam/schwarzkopf/fr/fr/brands/Men-perfect/home/thumbnails/men_perfect_de_thumbnails_home_pack_400x400.jpg")) ;
    list.add(new Contact("Marshall Alan", "52005985", "Son", "https://static.kiabishop.com/en/images/round-neck-sweater-blue-men-size-s-to-xxl-xd293_1_fr1.jpg")) ;
    list.add(new Contact("Marshall Annie", "52005985", "Nephew", "https://i0.wp.com/metro.co.uk/wp-content/uploads/2019/10/PRI_90428527.jpg?quality=90&strip=all&zoom=1&resize=644%2C406&ssl=1")) ;
    list.add(new Contact("Jane Jessie", "52005985", "My son John's wife", "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80")) ;
    list.add(new Contact("Marshall Andrew", "52005985", "Husband", "https://www.ashfordutah.com/wp-content/uploads/2016/08/Grumpy-Old-Men-OR-Suffering-From-Early-Onset-Dementia.jpg")) ;
    list.add(new Contact("Gin Elisa", "52005985", "My son Alan's wife", "https://media4.s-nbcnews.com/i/newscms/2019_39/1485236/garone-woman-today-main-190923_e4de8f71844c8b6b348a552d0a54b4e8.jpg")) ;
    list.add(new Contact("Marshall Hannah", "52005985", "My son John's child", "https://s.iw.ro/gateway/g/ZmlsZVNvdXJjZT1odHRwJTNBJTJGJTJG/c3RvcmFnZTA3dHJhbnNjb2Rlci5yY3Mt/cmRzLnJvJTJGc3RvcmFnZSUyRjIwMTkl/MkYwNyUyRjE2JTJGMTA5MzUwNF8xMDkz/NTA0X0JpYW5jYS1EZXZpcy5qcGcmdz02/NDAmaD00ODAmemM9MSZoYXNoPWIyNDcx/Nzg2NDc4OTk3MDFjOTgyMWE3YTJlMjgzZjll.thumb.jpg")) ;
    list.add(new Contact("Marshall Mark", "52005985", "My Brother", "https://video-images.vice.com/articles/5a708811983ca6693ecaabff/lede/1517325172233-olddude.jpeg?crop=1xw%3A1xh%3Bcenter%2Ccenter&resize=2000%3A")) ;

    for(int  i = 0  ; i< list.length ; i++){
      Contact contact  =list[i] ;

      items.add(
        TimelineModel(getItem(contact),
            position: i%2==0? TimelineItemPosition.left:TimelineItemPosition.right,
            iconBackground: Colors.purple,
            icon: Icon(Icons.person_pin,color: Colors.white,)) );

    }



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
          height: MediaQuery.of(context).size.height-headerSize,
          child: getList()
      ),
    );
  }

  Widget _getHeader(){
    return Container(
      height: headerSize,
      child: Center(child: Text("Contacts",style: TextStyle(fontSize: _textSizeValue+10 , color: Colors.white , fontWeight: FontWeight.bold), )),
    );
  }



  Widget getList(){
    return Timeline(children: items, position: TimelinePosition.Center);
  }

  Widget getItem(Contact contact){

    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(contact.url),
              height: 200,
              width: 200,
            ),
            Container( margin : EdgeInsets.symmetric(vertical: 10),child: Text(contact.name , style: TextStyle(fontSize: _textSizeValue+5),),),
            Container(child: Text("("+contact.desc+")", style: TextStyle(fontSize: _textSizeValue)),),
            Container( child: RaisedButton.icon(
                onPressed:(){
              _call(contact.phoneNumber);
            }, icon: Icon(Icons.phone,color: Colors.white,),color: Colors.green , label: Container(width: 80, child: Center(child: Text("Call",style: TextStyle(color: Colors.white),)))),),

          ],
        ),
      ),
    );
  }

  _call(String phoneNumber) {}

  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }
}
