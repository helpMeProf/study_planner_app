import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
Future<List<Map<String,dynamic>>> getUserData(String date) async {

  try{
    DateTime now = DateTime.now().toLocal();
    var currentTime = DateFormat('yyyy-MM-dd').format(now);
    var pref = await SharedPreferences.getInstance();
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var response = await http.get(Uri.parse(apiURL));
    var data = jsonDecode(response.body);
    List user_data = data["user_data"];
    List<Map<String,dynamic>> userData = [];
    user_data.forEach((element) { userData.add({
      "record_uid": element["record_uid"],
      "user_uid": element["user_uid"],
      "subject_name": element["subject_name"],
      "study_time": changeTimeFormat(element["study_time"]),
      "reg_date": element["reg_date"]
    });
    });
    return userData;
  }catch(err){
    print(err);
    return [];
  }
}
String changeTimeFormat(int time){
  var hour = (time~/3600)<10?'0${(time~/3600)}':(time~/3600);
  var min = (time%3600)~/60<10?'0${(time%3600)~/60}':(time%3600)~/60;
  var sec = (time%3600)%60<10?'0${(time%3600)%60}':(time%3600)%60;
  return "${hour}:${min}:${sec}";
}
Future<bool> sendUserData(String subject) async{
  try{
    DateTime now = DateTime.now().toLocal();
    var currentTime = DateFormat('yyyy-MM-dd').format(now);
    var pref = await SharedPreferences.getInstance();
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject});
    var response = await http.post(Uri.parse(apiURL),headers: {"Content-Type": "application/json"},body: jsonData);

    var data = jsonDecode(response.body);
    var state = data['success'];
    if(state=="FAIL") return false;
    return true;
  }catch(err){
    print(err);
    return false;
  }
}
Future<bool> removeUserData(String subject) async{
  try{
    DateTime now = DateTime.now().toLocal();
    var currentTime = DateFormat('yyyy-MM-dd').format(now);
    var pref = await SharedPreferences.getInstance();
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject});
    var response = await http.delete(Uri.parse(apiURL),headers: {"Content-Type": "application/json"},body: jsonData);

    var data = jsonDecode(response.body);
    var state = data['success'];
    if(state=="FAIL") return false;
    return true;
  }catch(err){
    print(err);
    return false;
  }
}
Future<bool> updateUserData(String subject, int time) async{
  try{
    DateTime now = DateTime.now().toLocal();
    var currentTime = DateFormat('yyyy-MM-dd').format(now);
    var pref = await SharedPreferences.getInstance();
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject,"study_time": time});
    var response = await http.put(Uri.parse(apiURL),headers: {"Content-Type": "application/json"},body: jsonData);

    var data = jsonDecode(response.body);
    var state = data['success'];
    if(state=="FAIL") return false;
    return true;
  }catch(err){
    print(err);
    return false;
  }
}
