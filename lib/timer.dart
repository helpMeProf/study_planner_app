import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
class TimerWidget extends StatefulWidget {
  final CameraController controller;
  final CameraDescription camera;
  final Interpreter interpreter;
  final FaceDetector faceDetector;

  const TimerWidget({Key? key, required this.controller, required this.camera, required this.interpreter, required this.faceDetector}) : super(key: key);


  @override
  State<TimerWidget> createState() => TimerWidgetState();

}

class TimerWidgetState extends State<TimerWidget> {
  AudioCache cache= AudioCache();
  late AudioPlayer player;
  @override
  void dispose(){
    super.dispose();
  }

  late Timer _timer;
  var _time=0;
  var _icon = Icons.play_arrow;
  bool _isPlaying = false;
  bool _isDetecting = false;
  bool _isPrepared =false;
  int _eyeTimeStart =0;
  int _notFoundStart =0;
  void click(){
    _isPlaying = !_isPlaying;
    if(_isPlaying){
      _icon = Icons.pause;
      _start();
    }else{
      _icon = Icons.play_arrow;
      _pause();
    }
  }
  void _start(){
    startDetecting();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _time++;
      });
    });
  }
  void _pause(){
    stopDetecting();
    _timer.cancel();
    setState(() {});
  }
  detected(){
    stopDetecting();
    _icon = Icons.play_arrow;
    _timer.cancel();
    setState(() {});
    _playFile();
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("알림"),
            content : Text("졸음을 감지했습니다! 확인을 눌러주세요"),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: (){
                  Navigator.pop(context);
                  _stopFile();
                },
              )
            ],
          );
        } );

  }
  _playFile() async{
    player= await cache.loop('alarm_sound.mp3');
  }
  _stopFile(){
    player?.stop();
  }
  stopDetecting(){
    if(widget.controller.value.isStreamingImages) {
      widget.controller.stopImageStream();
    }
  }
  startDetecting() {
    _isDetecting=false;
    if(widget.controller.value.isStreamingImages) return;
    _notFoundStart = _time;
    _eyeTimeStart =_time;
    widget.controller.startImageStream((image) {
      if(!_isDetecting){
        _isDetecting = true;
        ImageRotation rotation = rotationIntToImageRotation(widget.camera.sensorOrientation);
        var metadata = buildMetaData(image,rotation);
        var unit8list = planesToUnit8(image.planes);

        try {
          final GoogleVisionImage visionImage = GoogleVisionImage
              .fromBytes(unit8list, metadata);
          widget.faceDetector.processImage(visionImage).then((List<Face> result) {
            _isDetecting = false;
            if(result.isEmpty) {
              //print(_time);
              //print(_notFoundStart);
              if(_time - _notFoundStart >=10){
                detected();
              }
              //print("not found");
              return;
            }
            _notFoundStart = _time;
            List<Offset>? leftEyesPosition = result[0].getContour(FaceContourType.leftEye)?.positionsList;
            List<Offset>? rightEyesPosition = result[0].getContour(FaceContourType.rightEye)?.positionsList;



            imglib.Image img =imglib.Image.fromBytes(image.width, image.height, image.planes[0].bytes,format : imglib.Format.luminance);


            imglib.Image left_eyes = imglib.copyResize(crop_eye(img, leftEyesPosition!),width: 34,height: 26);
            imglib.Image right_eyes = imglib.copyResize(crop_eye(img,rightEyesPosition!),width: 34,height: 26);

            var left_eye_gray = grayscaleToByteListFloat32(left_eyes);
            var right_eye_gray = grayscaleToByteListFloat32(right_eyes);

            var left_eye_output = List.filled(1,0).reshape([1,1]);
            var right_eye_output = List.filled(1,0).reshape([1,1]);

            widget.interpreter.run(left_eye_gray,left_eye_output);
            widget.interpreter.run(right_eye_gray,right_eye_output);

            var left_open = left_eye_output[0][0];
            var right_open = right_eye_output[0][0];
            //print(left_open);
            //print(right_open);
            //print(result[0].leftEyeOpenProbability);
            //print(result[0].rightEyeOpenProbability);
            if(left_open<0.3&&right_open<0.3){
              //print('현재 시각 : ${_time}');
              //print('눈 감기 시작한 시작 : ${_eyeTimeStart}');
              if(_time-_eyeTimeStart>=5){
                detected();
              }
            }else {
              _eyeTimeStart = _time;
            }


          });
        }catch(e){
          //print("error발생");
        }

      }

    });
  }
  Widget _beforeStart(){
    return Center(
      child:Column(

        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text("카메라를 적당한 위치에 두어 5초 동안 얼굴이 감지가 되도록 해주세요."),
          ),
          OutlinedButton(
            onPressed: (){
              int tempTime=0;
              int detectingFaceTime=0;
              var tempTimer = Timer.periodic(Duration(seconds: 1), (timer) { tempTime++;});
              widget.controller.startImageStream((image) {
                if(_isDetecting) return;
                _isDetecting=true;
                ImageRotation rotation = rotationIntToImageRotation(widget.camera.sensorOrientation);
                var metadata = buildMetaData(image,rotation);
                var unit8list = planesToUnit8(image.planes);
                final GoogleVisionImage visionImage = GoogleVisionImage.fromBytes(unit8list, metadata);
                widget.faceDetector.processImage(visionImage).then((List<Face> result) {

                  if(result.isNotEmpty) {

                  if(tempTime - detectingFaceTime >=3){
                    //스트리밍 멈추고
                    //준비완료 해주고
                    //메시지도 띄워주고
                    //타이머도 멈춰야지
                    tempTimer.cancel();
                    if(widget.controller.value.isStreamingImages) {
                      widget.controller.stopImageStream();
                    }
                    _isPrepared=true;

                    showDialog(
                        context: context,
                        builder: (context){
                          return  AlertDialog(
                            title: Text("알림"),
                            content : Text("얼굴을 감지를 완료했습니다. 핸드폰을 움직이지 말아주세요."),
                            actions: [
                              TextButton(
                                child: Text("확인"),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        }
                    );
                  }
                  setState((){});
                  }else{
                    detectingFaceTime=tempTime;
                  }
                  _isDetecting = false;
                });

              });
            },
            child: Text("얼굴 찾기 시작"),
          ),
        ],
      )
    );
  }
  Widget _body(){
    var hour = (_time~/3600)<10?'0${(_time~/3600)}':(_time~/3600);
    var min = (_time%3600)~/60<10?'0${(_time%3600)~/60}':(_time%3600)~/60;
    var sec = (_time%3600)%60<10?'0${(_time%3600)%60}':(_time%3600)%60;
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$hour',style: TextStyle(fontSize: 80)),
              Text(':$min',style: TextStyle(fontSize: 80)),
              Text(':$sec',style: TextStyle(fontSize: 80)),
            ],

          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children : [
                IconButton(
                  padding: EdgeInsets.all(30),
                  onPressed: () {
                    click();
                  },
                  icon: Icon(_icon,size: 50,),
                ),
                IconButton(
                  padding: EdgeInsets.all(30),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.stop,size: 50)
                )
              ]
          )
        ],
      ),

    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _isPrepared==false?_beforeStart():_body()
    );
  }
}
