import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
Future<bool> tokenCheck(String jwt) async{
  try {
    String apiURL = "http://3.38.125.145:3000/api/tokenCheck";
    var response = await http.get(Uri.parse(apiURL),headers: {"x-access-token":jwt});
    var data = jsonDecode(response.body);
    if(data['success']=="FAIL" || data['success']=="NOTVALID") return false;
    return true;
  }catch(err){
    print(err);
    return false;
  }
}
Future<Map<String,dynamic>> login(String id, String password) async {
  try{
    String apiURL = "http://3.38.125.145:3000/api/users/login";
    var jsonData = jsonEncode({
      "id" : id,
      "password" : password
    });
    var response = await http.post(Uri.parse(apiURL),headers: {"Content-Type": "application/json"},body: jsonData);
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }catch(err){
    print(err);
    return {
      "success" : "error"
    };
  }
}
Future<int> signup(String id, String password, String name) async{
  try{
    String apiURL = "http://3.38.125.145:3000/api/users/signup";
    var jsonData = jsonEncode({
      "id" : id,
      "password" : password,
      "name" : name
    });
    var response = await http.post(Uri.parse(apiURL),headers: {"Content-Type": "application/json"},body: jsonData);
    var data = jsonDecode(response.body);
    print(data);
    var success = data['success'];
    if(success=="FAIL"){
      return 0;
    }else if(success == "error"){
      return -1;
    }
    else{
      return 1;
    }
  }catch(err){
    print(err);
    return -1;
  }
}
Future<List<Map<String,dynamic>>> getUserData(String date) async {

  try{

    var pref = await SharedPreferences.getInstance();
    String? jwtToken = pref.getString("jwtToken");
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${date}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var response = await http.get(Uri.parse(apiURL),headers: {"x-access-token":jwtToken!});
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
    String? jwtToken = pref.getString("jwtToken");
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject});
    var response = await http.post(Uri.parse(apiURL),headers: {"Content-Type": "application/json","x-access-token":jwtToken!},body: jsonData);

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
    String? jwtToken = pref.getString("jwtToken");
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject});
    var response = await http.delete(Uri.parse(apiURL),headers: {"Content-Type": "application/json","x-access-token":jwtToken!},body: jsonData);

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
    String? jwtToken = pref.getString("jwtToken");
    int uid = 1;
    if(pref.containsKey("uid")){
      uid = pref.getInt("uid") ?? 1;
    }
    String apiURL = "http://3.38.125.145:3000/api/users/${uid}/records/${currentTime}";
    //String apiURL = "http://3.38.125.145:3000/api/users/1/records/2021-10-21";
    //String apiURL = "http://localhost:3000/api/users/1/records/2021-10-21";
    var jsonData =jsonEncode({"subject_name": subject,"study_time": time});
    var response = await http.put(Uri.parse(apiURL),headers: {"Content-Type": "application/json","x-access-token":jwtToken!},body: jsonData);

    var data = jsonDecode(response.body);
    var state = data['success'];
    if(state=="FAIL") return false;
    return true;
  }catch(err){
    print(err);
    return false;
  }
}
