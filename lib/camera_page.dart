import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import './utils.dart';
//import 'dart:math' as math;

class Camera extends StatefulWidget{

  const Camera({Key? key}) : super(key : key);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera>{
  late CameraController controller;
  late CameraDescription camera;
  late FaceDetector faceDetector;
  late String appPath;
  late String res;
  late Interpreter interpreter;


  bool isDetecting = false;
  @override
  void initState(){
    super.initState();
    faceDetector= GoogleVision.instance.faceDetector(FaceDetectorOptions(enableLandmarks: true,enableContours: true, enableClassification: true));
  }

  Future<String?> get _localPath async{
    final dir = await getExternalStorageDirectory();
    //print(dir.path);
    return dir!.path;
  }
  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/test2.png');
  }
  Future<void> _initializeCamera() async {
    //appPath = await _localPath;
    //
    var cameras = await availableCameras();
    camera = cameras[0];
    controller = CameraController(camera, ResolutionPreset.ultraHigh);
    await controller.initialize();
    print("hihih");
    //res= (await Tflite.loadModel(model: "asset/model/final_model.tflite",labels: "asset/model/final_model_label.txt"))!;



  }
  @override
  void dispose(){
    //if(controller.value.isStreamingImages) controller.stopImageStream();
    controller?.dispose();

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
             return CameraPreview(controller);
           }else{
             return Center(child : CircularProgressIndicator());
           }
         },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
            //final ximage = await controller.takePicture();0
            final interpreter = await Interpreter.fromAsset("final_model.tflite");
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
                    //controller.stopImageStream();
                    imglib.Image img = convertYUV420(image);


                    imglib.Image left_eyes = imglib.copyResize(crop_eye(img, leftEyesPosition!),width: 34,height: 26);

                    var d = grayscaleToByteListFloat32(left_eyes);
                    print(left_eyes.width);
                    var output = List.filled(1,0).reshape([1,1]);
                    interpreter.run(d,output);
                    print(output);
                   //try{ Tflite.runModelOnBinary(binary: grayscaleToByteListFloat32(left_eyes)).then((value) {if(value==null) print("null");});}catch(e){print("can't load model");}



                    print(imglib.encodePng(left_eyes).length);
                    //print(imglib.encodePng(left_e));
                   /*_localFile.then((file){
                     file.writeAsBytes(imglib.encodePng(left_eyes));
                   });*/

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