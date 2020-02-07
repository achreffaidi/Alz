import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUI extends StatefulWidget {
  @override
  _SettingsUIState createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {

  double _textSizeValue = 20 ;
  @override
  void initState() {
   _loadTextSize() ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  _getBody() {

   return Container(
     margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
     child:
     Column(
       children: <Widget>[
         _getTextSizeSetting()
       ],
     ),
   );

  }


  Widget _getTextSizeSetting() {

    return Container(
      child : Card(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              _getTitle("Text Size"),
              Container(child:
              FluidSlider(
                value: _textSizeValue,
                onChangeEnd: (double newValue) async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setDouble("textSize", newValue) ;
                },
                onChanged: (double newValue) {
                  setState(() {
                    _textSizeValue = newValue;
                  });
                },
                min: 20.0,
                max: 100.0,
              ),
                )
            ],
          ),
        ),
      )
    ) ;

  }

  Widget _getTitle(String s) {
    return Container(
        height: 60,
        child:  Text(s  ,style: TextStyle(fontSize: _textSizeValue),)) ;
  }


  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }
}
