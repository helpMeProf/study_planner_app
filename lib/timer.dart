import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
class TimerWidget extends StatefulWidget {
  final CameraController controller;
  final Interpreter interpreter;
  final FaceDetector faceDetector;
  final CameraDescription camera;
  const TimerWidget({Key? key, required this.controller,required this.interpreter,required this.faceDetector,required this.camera}) : super(key: key);


  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool isDetecting = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: CameraPreview(widget.controller),
      ),
    );
  }
}
