import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class faceDetectorWidget extends StatefulWidget{
  final CameraController controller;
  final CameraDescription camera;
  final FaceDetector faceDetector;
  const faceDetectorWidget({Key? key, required this.controller, required this.camera, required this.faceDetector}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _faceDetectorWidgetState();
}
class _faceDetectorWidgetState extends State<faceDetectorWidget>{
  @override
  Widget build(context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}