import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:alz/Constant/Strings.dart';
import 'package:alz/Api/ImagesLinks.dart';


import 'Test.dart';

class AnimalsTest extends Test {
  String l1,l2,link1,link2;
  AnimalsTest(int answer , String v1 , String v2 , BuildContext context) :l1=v1,l2=v2, super(answer,context) {
   loadImages(v1, v2).then((link){
     firstChoice = generateAnswer(link.link1) ;
     secondChoice = generateAnswer(link.link2) ;
   });

    generateAnswerString();
  }

  @override
  Widget generateAnswer(link)  {
    Widget x;
    x = Center(child: Image.network(link),);
    return getBox(x);
  }

  @override
  void generateAnswerString() {
    if(correct==1)
      question = "Which one is the image of the "+ l1;
    else
      question = "Which one is the image of the "+ l2;
  }

  Future<Links> loadImages(String v1,String v2) async
  {
    ImagesLinks link;
     await http.get(baseUrl+"photosGame/game", headers: {
      "image1": v1,
      "image2": v2
    }).then((http.Response response){
      print("Loading Images : "+response.statusCode.toString());
      if(response.statusCode==200){
         link= imagesLinksFromJson(response.body);
      }});
    return link.links;
  }

}
