import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math';


import 'Test.dart';

class MathsTest extends Test {
  int op1,op2;
  String operateur;
  MathsTest(int answer ,int o1,String oper,int o2 , BuildContext context) :op1=o1,op2=o2,operateur=oper, super(answer,context) {

        switch(oper)
        {
          case "+":{
            o1= answer == 1 ? op1+op2: op2+op1+Random().nextInt(30)+1;
            o2= answer == 2 ? op1+op2 : op1+op2-Random().nextInt(15)-1;
          } break;
          case "*":{
            o1= answer == 1 ? op1*op2 : op2*op1+Random().nextInt(30)+1;
            o2= answer == 2 ? op1*op2 : op1*op2-Random().nextInt(15)-1;
          } break;
          case "-":{
            o1= answer == 1 ? op1-op2 : op1-op2+Random().nextInt(30)+1;
            o2= answer == 2 ? op1-op2 : op1-op2-Random().nextInt(15)-1;

          } break;

        }
    firstChoice = generateAnswer(o1) ;
    secondChoice = generateAnswer(o2) ;
    generateAnswerString();
  }

  @override
  Widget generateAnswer(value) {
    Widget x ;
    x = Center(child: Text(value.toString(),style: TextStyle(fontSize: 70 , fontWeight: FontWeight.bold),),);
    return getBox(x);
  }

  @override
  void generateAnswerString() {

      question = "What is the result of this operation : " +op1.toString()+" "+operateur+" "+op2.toString();

  }



}