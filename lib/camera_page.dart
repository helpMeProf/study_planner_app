import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
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


  bool isDetecting = false;
  @override
  void initState(){
    super.initState();
    faceDetector= GoogleVision.instance.faceDetector(FaceDetectorOptions(enableLandmarks: true,enableContours: true, enableClassification: true));
  }

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    camera = cameras.length>=2?cameras[1]:cameras.first;
    controller = CameraController(camera, ResolutionPreset.ultraHigh);
    interpreter = await Interpreter.fromAsset("final_model.tflite");
    await controller.initialize();
  }
  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
    );
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
        body : FutureBuilder<void>(
         future: _initializeCamera(),
         builder: (context,snapshot) {
           if(snapshot.connectionState == ConnectionState.done){
             return DraggableScrollableSheet(
               initialChildSize: 1.0,
               builder: (context,scrollController){
                 return SingleChildScrollView(
                   child: Container(
                       width: controller.value.previewSize?.width,
                       height: controller.value.previewSize?.height,
                       child: TimerWidget(controller: controller,interpreter: interpreter, faceDetector: faceDetector,camera: camera)
                   )
                 );
               },
             );
           }else{
             return Center(child : CircularProgressIndicator());
           }
         },
        ),
      floatingActionButton: FloatingActionButton(onPressed: () async {

        if(controller.value.isStreamingImages) return;
          controller.startImageStream((image) {

          if(!isDetecting){
            isDetecting = true;
            ImageRotation rotation = rotationIntToImageRotation(camera.sensorOrientation);
            var metadata = buildMetaData(image,rotation);
            var unit8list = planesToUnit8(image.planes);
            try {
              final GoogleVisionImage visionImage = GoogleVisionImage
                  .fromBytes(unit8list, metadata);
                faceDetector.processImage(visionImage).then((List<Face> result) {
                isDetecting = false;
                if(result.isEmpty) {print("not found"); return null;}
                print(result[0].getContour(FaceContourType.leftEye)?.positionsList.toString());

                List<Offset>? leftEyesPosition = result[0].getContour(FaceContourType.leftEye)?.positionsList;
                List<Offset>? rightEyesPosition = result[0].getContour(FaceContourType.rightEye)?.positionsList;

                imglib.Image img = convertYUV420(image);

                imglib.Image left_eyes = imglib.copyResize(crop_eye(img, leftEyesPosition!),width: 34,height: 26);
                imglib.Image right_eyes = imglib.copyResize(crop_eye(img,rightEyesPosition!),width: 34,height: 26);

                var left_eye_gray = grayscaleToByteListFloat32(left_eyes);
                var right_eye_gray = grayscaleToByteListFloat32(right_eyes);

                var left_eye_output = List.filled(1,0).reshape([1,1]);
                var right_eye_output = List.filled(1,0).reshape([1,1]);

                interpreter.run(left_eye_gray,left_eye_output);
                interpreter.run(right_eye_gray,right_eye_output);
              });
            }catch(e){
              print("error발생");
            }
          }
        });
      },
        child: Icon(Icons.play_arrow),
      ),
    );

  }
}