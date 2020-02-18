import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Test.dart';

class ColorsTest extends Test {
  Color color1,color2 ;
  String l1,l2;
  ColorsTest(int answer , String v1 ,Color c1, String v2 ,Color c2 , BuildContext context) :l1=v1,l2=v2,color1=c1,color2=c2, super(answer,context) {
    firstChoice = generateAnswer(c1) ;
    secondChoice = generateAnswer(c2) ;
    generateAnswerString();
  }

  @override
  Widget generateAnswer(value) {
    Widget x ;
    x = Center(child: Container(color: value,margin: EdgeInsets.all(3),),);
    return getBox(x);
  }

  @override
  void generateAnswerString() {
    if(correct==1)
      question = "Which Color is the "+ l1+" color" ;
    else
      question = "Which Color is the "+ l2+" color" ;
  }



}