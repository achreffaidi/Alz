import 'package:alz/Constant/colors.dart';
import 'package:alz/Api/Contact.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alz/Constant/Strings.dart';
import 'package:url_launcher/url_launcher.dart' as url_launch;


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
          height: MediaQuery.of(context).size.height-165,
          child: getList()
      ),
    );
  }

  Widget _getHeader(){
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
            child: Center(
        child :Text("Contacts",style: TextStyle(fontSize: _textSizeValue+30 , color: Colors.white , fontWeight: FontWeight.bold))
        )
        ),
        SizedBox(width: 100,)],
         ),
    );
  }



  Widget getList(){
    return contacts==null?Container():Container(
      margin: EdgeInsets.symmetric(horizontal: 20.5,vertical: 5),
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
              width: 250,
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
                      onPressed:() async {
                        var url = 'tel:'+contact.number.toString();
                        if (await url_launch.canLaunch(url)) {
                        await url_launch.launch(url);
                        } else {
                        throw 'Could not launch $url';
                        }

                      },
                      icon: Icon(Icons.phone,color: Colors.white,size: 40,),
                      color: Colors.green ,
                      label: Container(width: 122,

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
