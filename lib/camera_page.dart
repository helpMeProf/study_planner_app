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

  const Camera({Key? key}) : super(key : key);
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
    faceDetector= GoogleVision.instance.faceDetector(FaceDetectorOptions(enableLandmarks: true,enableContours: true, enableClassification: true));
  }

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    camera = cameras.length>=2?cameras[1]:cameras.first;
    controller = CameraController(camera, ResolutionPreset.high);
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
        body : FutureBuilder<void>(
         future: _initializeCamera(),
         builder: (context,snapshot) {
           if(snapshot.connectionState == ConnectionState.done){
             return DraggableScrollableSheet(
               initialChildSize: 1.0,
               builder: (context,scrollController){
                 return SingleChildScrollView(
                   padding: const EdgeInsets.all(20),
                   child: Column(
                     children: [
                       SizedBox(
                         child: AspectRatio(
                             aspectRatio: controller.value.aspectRatio,
                             child: CameraPreview(controller),
                             )
                         ),
                       SizedBox(
                           child:AspectRatio(
                             aspectRatio: controller.value.aspectRatio,
                             child: TimerWidget(faceDetector: faceDetector,camera: camera,controller: controller,interpreter: interpreter),
                           )
                       )
                     ],
                   )
                 );
               },
             );
           }else{
             return Center(child : CircularProgressIndicator());
           }
         },
        ),
    );

  }
}