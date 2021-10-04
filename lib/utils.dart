import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image/image.dart' as imglib;
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';
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

imglib.Image convertYUV420(CameraImage image) {
  var img = imglib.Image(image.width, image.height); // Create Image buffer

  Plane plane = image.planes[0];
  const int shift = (0xFF << 24);

  // Fill image buffer with plane[0] from YUV420_888
  for (int x = 0; x < image.width; x++) {
    for (int planeOffset = 0;
    planeOffset < image.height * image.width;
    planeOffset += image.width) {
      final pixelColor = plane.bytes[planeOffset + x];
      // color: 0x FF  FF  FF  FF
      //           A   B   G   R
      // Calculate pixel color
      var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

      img.data[planeOffset + x] = newVal;
    }
  }

  return img;
}
imglib.Image crop_eye(imglib.Image img,List<Offset> eye_points){
  List<double> dx=[];
  List<double> dy=[];
  eye_points.forEach((element) { 
    dx.add(element.dx);
    dy.add(element.dy);
  });
  var min_dx = dx.reduce((value, element) => math.min(value,element)).floor();
  var max_dx = dx.reduce((value, element) => math.max(value,element)).ceil();
  var min_dy = dy.reduce((value, element) => math.min(value,element)).floor();
  var max_dy = dy.reduce((value, element) => math.max(value,element)).ceil();
  return imglib.copyCrop(img, min_dx, min_dy, max_dx-min_dx, max_dy-min_dy);
}
Uint8List grayscaleToByteListFloat32(imglib.Image image){
  var convertedBytes = Float32List(1*34 * 26*1);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < 26; i++) {
    for (var j = 0; j < 34; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = imglib.getLuminance(pixel) / 255.0;
    }
  }
  return convertedBytes.buffer.asUint8List();
}
Future<String?> get localPath async{
    final dir = await getExternalStorageDirectory();
    //print(dir.path);
    return dir!.path;
  }
  Future<File> get localFile async{
    final path = await localPath;
    return File('$path/test2.png');
  }