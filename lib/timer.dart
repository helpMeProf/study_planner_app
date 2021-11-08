import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/transport_util.dart';
import 'package:flutter_app/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
class TimerWidget extends StatefulWidget {
  final CameraController controller;
  final CameraDescription camera;
  final Interpreter interpreter;
  final FaceDetector faceDetector;
  final String subjectName;

  const TimerWidget({Key? key, required this.controller, required this.camera, required this.interpreter, required this.faceDetector,required this.subjectName}) : super(key: key);


  @override
  State<TimerWidget> createState() => TimerWidgetState();

}

class TimerWidgetState extends State<TimerWidget>{
  AudioCache cache= AudioCache();
  late AudioPlayer player;
  late Timer _timer;
  bool isTimerInit = false;
  var _time=0;
  var _icon = Icons.play_arrow;
  bool _isPlaying = false;
  bool _isDetecting = false;
  int _selectedWidget =0;
  bool _isSleep = false;
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
    if(_isSleep) return;
    _isSleep=true;
    stopDetecting();
    _icon = Icons.play_arrow;
    _timer.cancel();
    setState(() {});
    _playFile();
    _makeDialog("알림", "졸음을 감지했습니다! 확인을 눌러주세요", (context) {
      Navigator.pop(context);
      _stopFile();
    });
  }
  _playFile() async{
    player= await cache.loop('alarm_sound.mp3');
  }
  _stopFile(){
    player?.stop();
  }
  _saveRecord() async{
    bool ret = await updateUserData(widget.subjectName,_time);
    if(ret){
      Fluttertoast.showToast(msg: "공부시간을 기록했습니다!");
    }else{
      Fluttertoast.showToast(msg: "공부시간 기록을 실패했습니다! 인터넷 연결을 확인해주세요.");
    }

  }
  stopDetecting(){
    if(widget.controller.value.isStreamingImages) {
      widget.controller.stopImageStream();
    }
  }
  startDetecting() {
    _isDetecting=false;
    _isSleep = false;
    if(widget.controller.value.isStreamingImages) return;
    _notFoundStart = _time;
    _eyeTimeStart =_time;
    widget.controller.startImageStream((image) {
      if(!_isDetecting){
        _isDetecting = true;
        ImageRotation rotation = rotationIntToImageRotation(widget.camera.sensorOrientation);
        var metadata = buildMetaData(image,rotation);
        var unit8list = planesToUnit8(image.planes);
        final GoogleVisionImage visionImage = GoogleVisionImage.fromBytes(unit8list, metadata);
          widget.faceDetector.processImage(visionImage).then((List<Face> result) {

            if(result.isEmpty) {
              if(_time - _notFoundStart >=10){
                detected();
              }
              print("not found");
            }else{
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
            }
            _isDetecting = false;
          });

      }

    });
  }
  _makeDialog(title,content,callback){
    showDialog(
        context: context,
        builder: (context){
          return  AlertDialog(
            title: Text(title),
            content : Text(content),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: (){
                  callback(context);
                },
              )
            ],
          );
        }
    );
  }
  Widget _beforeStartDetecting(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text("얼굴을 인식하는 중입니다. 얼굴이 잘 인식되는 곳에 카메라를 고정시켜주세요.")
        ),
        OutlinedButton(
            onPressed: (){
              _timer.cancel();
              stopDetecting();
              setState((){
                _selectedWidget = 0;
              });
            },
            child:Text("취소하기")
        )
      ],
    );
  }
  Widget _beforeStart(){
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: const Text("카메라를 적당한 위치에 두어 5초 동안 얼굴이 감지가 되도록 해주세요."),
          ),
          OutlinedButton(
            onPressed: (){
              setState((){_selectedWidget = 1;});
              int tempTime=0;
              int detectingFaceTime=0;
              bool isFaceDetected = false;
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) { tempTime++;});
              isTimerInit = true;
              widget.controller.startImageStream((image) {
                if(_isDetecting) return;
                _isDetecting=true;
                ImageRotation rotation = rotationIntToImageRotation(widget.camera.sensorOrientation);
                //메타데이터 최적화 할 수 있을 듯
                var metadata = buildMetaData(image,rotation);
                var unit8list = planesToUnit8(image.planes);
                final GoogleVisionImage visionImage = GoogleVisionImage.fromBytes(unit8list, metadata);
                widget.faceDetector.processImage(visionImage).then((List<Face> result) {

                  if(result.isNotEmpty) {
                    if(tempTime - detectingFaceTime >=5 && isFaceDetected == false){
                      isFaceDetected = true;
                      _timer.cancel();
                      stopDetecting();
                      _makeDialog("알림","얼굴을 감지를 완료했습니다. 핸드폰을 움직이지 말아주세요.",(context){
                        Navigator.pop(context);
                      });
                      setState((){
                        _selectedWidget = 2;
                      });
                    }
                  }else{
                    detectingFaceTime=tempTime;
                  }
                  _isDetecting = false;
                });
              });
            },
            child: const Text("얼굴 찾기 시작"),
          )
        ],
      ),
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
              Text('$hour',style: const TextStyle(fontSize: 50)),
              Text(':$min',style: const TextStyle(fontSize: 50)),
              Text(':$sec',style: const TextStyle(fontSize: 50)),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children : [
                Flexible(flex: 1,child : IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  onPressed: () {
                    click();
                  },
                  icon: Icon(_icon,size: 50,),
                )),
                Flexible(flex:1,child:IconButton(
                    padding:  const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.stop,size: 50)
                )),
              ]
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
          Text("과목 : ${widget.subjectName}",style: const TextStyle(fontSize: 30,overflow: TextOverflow.ellipsis)),
        ],
      ),

    );
  }
  Widget currentWidget(){
    if(_selectedWidget ==0){
      return _beforeStart();
    }
    if(_selectedWidget ==1){
      return _beforeStartDetecting();
    }
    return _body();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWidget()
    );
  }
  @override
  void initState(){
    super.initState();
    print("timer 초기화");

  }

  @override
  void dispose(){
    print("timer dispose");
    if(isTimerInit) _timer?.cancel();
    //_saveRecord();
    super.dispose();
  }
}
