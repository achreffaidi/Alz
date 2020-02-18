import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Api/ImagesLinks.dart';


import 'Test.dart';

class AnimalsTest extends Test {
  String l1,l2,link1,link2;
  AnimalsTest(int answer , String v1 , String v2 ,String link1 , String link2 ,  BuildContext context) :l1=v1,l2=v2, super(answer,context) {

       firstChoice = generateAnswer(link1) ;
       secondChoice = generateAnswer(link2) ;

    generateAnswerString();
  }

  @override
  Widget generateAnswer(link)  {
    Widget x;
    x = Container(

      child:Container(
        decoration: BoxDecoration(
          image: DecorationImage(image : Image.network(link,fit: BoxFit.cover).image,fit: BoxFit.cover)
        ),
      ) );
      // child: );
    return getBox(x);
  }

  @override
  void generateAnswerString() {
    if(correct==1)
      question = "Which one is the image of the "+ l1;
    else
      question = "Which one is the image of the "+ l2;
  }



}
