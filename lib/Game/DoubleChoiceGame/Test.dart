import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

abstract class Test{

  Test(int s , BuildContext context){
    this.context = context;
    correct = s ;
    _boxSize = 300 ;
  }

  BuildContext context ;
  int correct ;
  Widget firstChoice ;
  Widget secondChoice ;
  double _boxSize ;
  String question ;


  Widget getFirstChoice()=> firstChoice ;
  Widget getSecondChoice()=> secondChoice ;

  Widget generateAnswer(value) ;

  void generateAnswerString();

  void readQuestion(){
    Toast.show(question, context) ;
  }
  Widget getBox(Widget body ){

    return Container(
      height: _boxSize,
      width: _boxSize,
      child : Card(
        child: Container(
          child: body,
        ),
      )
    );

  }


}