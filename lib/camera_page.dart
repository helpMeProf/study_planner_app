import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image/image.dart' as imglib;

//import 'dart:math' as math;

class Camera extends StatefulWidget{

  const Camera({Key? key}) : super(key : key);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera>{
  late CameraController controller;
  late CameraDescription camera;
  final FaceDetector faceDetector = GoogleVision.instance.faceDetector(FaceDetectorOptions(enableLandmarks: true,enableContours: true, enableClassification: true));
  bool isDetecting = false;
  @override
  void initState(){
    super.initState();

  }
  ImageRotation rotationIntToImageRotation(int rotation){
    switch(rotation){
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        return ImageRotation.rotation270;
    }
  }
  GoogleVisionImageMetadata buildMetaData(
      CameraImage image,
      ImageRotation rotation
      ){
    return GoogleVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(),image.height.toDouble()),
        rotation: ImageRotation.rotation0,
        planeData: image.planes.map((Plane plane) {
          return GoogleVisionImagePlaneMetadata(bytesPerRow: plane.bytesPerRow,height: plane.height,width: plane.width);
        }).toList()
    );
  }
  Uint8List planesToUnit8(List<Plane> planes){
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    print(cameras.length);
    camera = cameras.first;
    controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();

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
            //final ximage = await controller.takePicture();
            controller.startImageStream((image) {
              if(!isDetecting){
                  isDetecting = true;
                ImageRotation rotation = rotationIntToImageRotation(camera.sensorOrientation);
                var metadata = buildMetaData(image,rotation);
                var unit8list = planesToUnit8(image.planes);
                final GoogleVisionImage visionImage = GoogleVisionImage.fromBytes(unit8list,metadata);
                faceDetector.processImage(visionImage).then((List<Face> result) {
                  if(result.isEmpty) return;
                  print(result.length);
                  print(result[0].getContour(FaceContourType.leftEye)?.positionsList.toString());
                  imglib.Image img = imglib.Image.fromBytes(image.width, image.height, unit8list.toList());
                  //var imgs = imglib.copyCrop(img,0 , 0, image.width, image.height);
                  File('test.png').writeAsBytes(imglib.encodePng(img));
                  controller.stopImageStream();
                  isDetecting = false;
                });
                }
            });
          },
          child: Icon(Icons.play_arrow),
        ),
    );

  }
}