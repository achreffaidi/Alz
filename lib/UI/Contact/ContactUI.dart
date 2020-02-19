import 'package:alz/Constant/colors.dart';
import 'package:alz/Api/Contact.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alz/Constant/Strings.dart';


class ContactUI extends StatefulWidget {
  @override
  _ContactUIState createState() => _ContactUIState();
}


class _ContactUIState extends State<ContactUI> {
  List<ContactsList> contacts;
  double headerSize = 120 ;
  double _textSizeValue = 20 ;

  List<TimelineModel> items = [
  ];
  @override
  void initState() {
    _loadTextSize();
    _loadContacts();

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

      child: Container(
          height: MediaQuery.of(context).size.height-headerSize,
          child: getList()
      ),
    );
  }

  Widget _getHeader(){
    return Container(
      height: headerSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(child: Container(width: MediaQuery.of(context).size.width*0.1,
            height: headerSize,
            child: Icon(Icons.arrow_back,color: Colors.white,size: _textSizeValue+20,),
          ),
          onTap: (){
          Navigator.pop(context);
          },),
        Container(width: MediaQuery.of(context).size.width*0.8,
            child: Center(
        child :Text("Contacts",style: TextStyle(fontSize: _textSizeValue+15 , color: Colors.white , fontWeight: FontWeight.bold))
        )
        )],
         ),
    );
  }



  Widget getList(){
    return contacts==null?Container():Container(
      margin: EdgeInsets.symmetric(horizontal: 20.5,vertical: 20),
       // height:MediaQuery.of(context).size.height-400 ,
        child :GridView.count(
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 1.6,
          crossAxisCount: 3,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(contacts.length, (index) {
            return Center(child:getItem(contacts[index]));
          }),
        ),

    ) ;
  }

  Widget getItem(ContactsList contact){

    return  Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
        //padding: EdgeInsets.symmetric(vertical: 8),

        height: 200,
        width: 400,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30)
            ),
            child: Image.network(contact.imageUrl,height: 200,width: 150,),
          ),
            Container(
              width: 243,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(child:Text(contact.name,style: TextStyle(fontSize: _textSizeValue+10,fontWeight: FontWeight.bold,color: c1),),),
                Center(child:Text(contact.description, style: TextStyle(fontSize: _textSizeValue+5,))),
                Container(
                  height: 50,
                  child:ClipRRect(
                  borderRadius: BorderRadius.only(

                      bottomRight: Radius.circular(30)
                  ),
                  child: RaisedButton.icon(
                      onPressed:(){
                        _call(contact.number.toString());
                      },
                      icon: Icon(Icons.phone,color: Colors.white,size: 40,),
                      color: Colors.green ,
                      label: Container(width: 120,

                          child: Center(
                              child: Text("Call",style: TextStyle(color: Colors.white,fontSize: _textSizeValue),))
                      )
                  ),
                ),
                ),

              ],
            ))
          ],
        ),
      );
  }

  _call(String phoneNumber) {}

  void _loadContacts() async {
    http.get(baseUrl+"contacts").then((http.Response response){

      contacts = contactFromJson(response.body).contactsList;
      print(response.body) ;
      setState(() {

      });
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
