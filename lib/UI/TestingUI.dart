import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TestingUI extends StatefulWidget {
  @override
  _TestingUIState createState() => _TestingUIState();
}

class _TestingUIState extends State<TestingUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(onPressed: play , child: Text("Play"),),
    );
  }


  play() async {
    AudioPlayer audioPlayer = AudioPlayer();
String url = "https://bioit.blob.core.windows.net/speech/speech61043a47-a8c7-47f2-b062-573b85765947" ;
    int result = await audioPlayer.play(url);
    if (result == 1) {
      // success
    }
  }


}
