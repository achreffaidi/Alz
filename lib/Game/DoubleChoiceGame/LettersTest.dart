import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Test.dart';

class LettersTest extends Test {
  String l1,l2 ;
  LettersTest(int answer , String v1 , String v2 , BuildContext context) :l1=v1,l2=v2, super(answer,context) {
   firstChoice = generateAnswer(l1) ;
   secondChoice = generateAnswer(l2) ;
   generateAnswerString();
  }

  @override
  Widget generateAnswer(value) {
    Widget x ;
    x = Center(child: Text(value , style: TextStyle(fontSize: 80 , fontWeight: FontWeight.bold),),);
    return getBox(x);
  }

  @override
  void generateAnswerString() {
    if(correct==1)
    question = "Which Letter is the Letter "+ l1 ;
    else
    question = "Which Letter is the Letter "+ l2 ;
  }



}