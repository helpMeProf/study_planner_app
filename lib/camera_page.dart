import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'timer.dart';

class Camera extends StatefulWidget{
  final String subjectName;
  const Camera({required this.subjectName,Key? key}) : super(key : key);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera>{
  late CameraController controller;
  late CameraDescription camera;
  late FaceDetector faceDetector;

  late final interpreter;
  int closedCount=0;
  Icon icon = Icon(Icons.play_arrow);

  bool isDetecting = false;
  @override
  void initState(){
    super.initState();
    faceDetector= GoogleVision.instance.faceDetector(const FaceDetectorOptions(enableLandmarks: true,enableContours: true, enableClassification: true));
  }

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    camera = cameras.length>=2?cameras[1]:cameras.first;
    controller = CameraController(camera, ResolutionPreset.low);
    interpreter = await Interpreter.fromAsset("final_model.tflite");
    await controller.initialize();
  }
  @override
  void dispose(){

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        backgroundColor: Color(0xFFE0E3FC),
        body : FutureBuilder<void>(
         future: _initializeCamera(),
         builder: (context,snapshot) {
           if(snapshot.connectionState == ConnectionState.done){
             return Center(
               child: SingleChildScrollView(

                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Stack(
                       children: [
                         SizedBox(
                           width: MediaQuery.of(context).size.width*0.8,
                           height: MediaQuery.of(context).size.height*0.6,
                           child: Container(
                             color: Color(0xF0A7AFF7),
                           ),
                           ),
                         SizedBox(
                           width: MediaQuery.of(context).size.width*0.8,
                           height: MediaQuery.of(context).size.height*0.6,
                           child: Card(
                               color: Colors.white,
                               child: CameraPreview(controller)
                           ),
                         ),

                       ],
                     ),
                     Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                     Stack(
                       children: [
                         SizedBox(
                           width: MediaQuery.of(context).size.width*0.8,
                           height: MediaQuery.of(context).size.height*0.5,
                           child: Container(
                             color: Color(0xF0A7AFF7),
                           ),
                         ),
                         SizedBox(
                           width: MediaQuery.of(context).size.width*0.8,
                           height: MediaQuery.of(context).size.height*0.5,
                           child: Card(
                             child: TimerWidget(faceDetector: faceDetector,camera: camera,controller: controller,interpreter: interpreter,subjectName: widget.subjectName),
                           ),
                         ),
                       ],
                     )


                   ],
                 ),
               ),
             );
           }else{
             return Center(child : CircularProgressIndicator());
           }
         },
        ),
    );

  }
}