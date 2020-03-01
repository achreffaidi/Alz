import 'dart:io';

import 'package:alz/Constant/Strings.dart';
import 'package:alz/Constant/colors.dart';
import 'package:alz/tools/Images.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_camera_ml_vision/const.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FaceDetect extends StatefulWidget {
  @override
  _FaceDetectState createState() => _FaceDetectState();
}

class _FaceDetectState extends State<FaceDetect> {

  double _textSizeValue = 20 ;
  ProgressDialog pr  ;
  AudioPlayer audioPlayer ;
  File file;
  List<Face> _faces = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        minFaceSize: 0.8,
    enableTracking: true,
    mode: FaceDetectorMode.fast,
  ));
  String name = "";
  String infos = "";



  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    pr =new ProgressDialog(this.context,type: ProgressDialogType.Normal);
    pr.update(message:"Getting Infos ... ");
    canStartTheProccess = true ;

    AudioPlayer.logEnabled = true;
     audioPlayer = AudioPlayer();

    _loadTextSize();

    audioPlayer.onPlayerCompletion.listen((object){
      canStartTheProccess = true;
      canTakePicture = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
                "assets/background3.png",
              ).image,
              fit: BoxFit.fill),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 250 ,
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
                      )),
                  Text("Face Recognition"  ,style: TextStyle(fontSize: _textSizeValue+20 , color: Colors.white , fontWeight: FontWeight.bold),),
                  SizedBox(width: 100,)
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top:45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: <Widget>[

                  SizedBox(

                    width: MediaQuery.of(context).size.width-300,
                    height: MediaQuery.of(context).size.height/3,
                    child: CameraMlVision<List<Face>>(
                      key: _scanKey,
                      cameraLensDirection: cameraLensDirection,
                      detector: detector.processImage,
                      overlayBuilder: (c) {
                        return CustomPaint(
                          painter: FaceDetectorPainter(
                              _scanKey.currentState.cameraValue.previewSize.flipped,
                              _faces,
                              reflection:
                                  cameraLensDirection == CameraLensDirection.front),
                        );
                      },
                      onResult: (faces) {
                        if (faces == null || faces.isEmpty || !mounted) {
                          return;
                        }

                        if(canStartTheProccess)startSendingPicture(context);

                        setState(() {
                          _faces = []..addAll(faces);
                        });
                      },
                      onDispose: () {
                        detector.close();
                      },
                    ),
                  ),

                  Container(

                    width: MediaQuery.of(context).size.width-200,
                    height: MediaQuery.of(context).size.height/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(
                             Radius.circular(40.0)

                      )
                      ,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius:0.2,
                          offset: new Offset(-3, -2.0),
                        )
                      ],),

                    margin: EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(
                            name,

                            style: TextStyle(fontSize: _textSizeValue+25  , fontWeight: FontWeight.bold , color: c1), textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          child: Text(
                            infos,

                            style: TextStyle(fontSize: _textSizeValue+20  , fontWeight: FontWeight.bold , color: Colors.black), textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                 /* file == null
                      ? Container(
                          child: Text("No IMAGE"),
                        )
                      : Image.memory(myImage)*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSendingPicture(BuildContext context) async {
    print("Detecting Face");
    //  print("can take picture : " + canTakePicture.toString());
    // print("can Proccess Picture  : " + canStartTheProccess.toString());
    if (canStartTheProccess) {
      canTakePicture = true;

      print("Proccessing the image ");
      canStartTheProccess = false;
      file =  File.fromRawPath(myImage);
      print("Picture saved successfully");
      await new Future.delayed(const Duration(milliseconds: 500));

      uploadImage(context) ;
      setState(() {

      });
    }
  }

  void uploadImage(BuildContext context) async {
    pr.show();

    var uri = Uri.parse(baseUrl + "achref");
    print(uri);
    var request = new MultipartRequest("POST", uri);


    request.files.add(new MultipartFile.fromBytes("file", myImage,
        filename: DateTime.now().toIso8601String()));

    var response = await request.send();

  pr.hide();
    print(response.headers);
    Toast.show(
        "StateCode : " +
            response.statusCode.toString(),
        context);
    switch (response.statusCode) {
      case 200:
        name = response.headers["name"] ;
        infos = response.headers["userdata"] ;
        setState(() {

        });


      await  play(response.headers["voice"]);


        break;
      case 300:
        print("Unable To Detect Any Face| ");
        name = "Unable To Detect Any Face";
        infos="";
        canStartTheProccess = true;
        canTakePicture = true;
        setState(() {});
        break;
      case 301:
        print("Unable To Recongnize The Face | ");
        name = "Unable To Recongnize The Face";
        infos="";
        canStartTheProccess = true;
        canTakePicture = true;
        setState(() {});
        break;
    }
  }

  play(String url ) async {

    await new Future.delayed(const Duration(seconds:1 ));
    int result = await audioPlayer.play(url);


    if (result == 1) {
      // success
    }
  }

  void _loadTextSize()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textSizeValue = ( prefs.getDouble("textSize")??20 ) ;
    print("loaded value = "+_textSizeValue.toString()) ;
    setState(() {

    });

  }

}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.imageSize, this.faces, {this.reflection = false});

  final bool reflection;
  final Size imageSize;
  final List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (Face face in faces) {
      final faceRect =
          _reflectionRect(reflection, face.boundingBox, imageSize.width);
      canvas.drawRect(
        _scaleRect(
          rect: faceRect,
          imageSize: imageSize,
          widgetSize: size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

Rect _reflectionRect(bool reflection, Rect boundingBox, double width) {
  if (!reflection) {
    return boundingBox;
  }
  final centerX = width / 2;
  final left = ((boundingBox.left - centerX) * -1) + centerX;
  final right = ((boundingBox.right - centerX) * -1) + centerX;
  return Rect.fromLTRB(left, boundingBox.top, right, boundingBox.bottom);
}

Rect _scaleRect({
  @required Rect rect,
  @required Size imageSize,
  @required Size widgetSize,
}) {
  final scaleX = widgetSize.width / imageSize.width;
  final scaleY = widgetSize.height / imageSize.height;

  final scaledRect = Rect.fromLTRB(
    rect.left.toDouble() * scaleX,
    rect.top.toDouble() * scaleY,
    rect.right.toDouble() * scaleX,
    rect.bottom.toDouble() * scaleY,
  );
  return scaledRect;
}
