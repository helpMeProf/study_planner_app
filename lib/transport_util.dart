Future<List<Map<String,dynamic>>> getUserDate(String date) async {
  List<Map<String,dynamic>> userData = [];
  var data = {
    'subject' : '수학 과학 수학 과학 영어 과학 영어 과학 영어 과학 영어 맛나',
    'studyTime' : '0',
    'regDage' : '2021-09-30'
  };
  var data2 = {
    'subject' : '과학',
    'studyTime' : '0',
    'regDage' : '2021-09-30'
  };
  userData.add(data);
  userData.add(data2);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data);
  userData.add(data2);


  return userData;
}