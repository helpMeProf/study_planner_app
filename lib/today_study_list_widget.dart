import 'package:flutter/material.dart';
import 'package:flutter_app/camera_page.dart';
import 'package:flutter_app/transport_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class TodayStudyListWidget extends StatefulWidget {
  const TodayStudyListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayStudyListWidgetState();
}

class _TodayStudyListWidgetState extends State<TodayStudyListWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  void addSubject() async {
    String subject = _textEditingController.value.text;
    if (subject == "") {
      Fluttertoast.showToast(msg: "과목이름을 입력해주요!");
    } else {
      var result = await sendUserData(subject);
      setState(() {
        _textEditingController.text = '';
      });
      if (result) {
        Fluttertoast.showToast(msg: "과목을 등록했습니다!");
      } else {
        Fluttertoast.showToast(
            msg: "추가에 실패했습니다. 인터넷 연결 혹은 이미 존재하고 있는 과목인지 확인해주세요!",
            gravity: ToastGravity.TOP);
      }
    }
  }

  Future<bool> removeSubject(String subject) async {
    bool ret = await removeUserData(subject);
    return ret;
  }

  @override
  Widget build(context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Text('오늘의 공부 목록',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),

            Container(
              padding: EdgeInsets.all(20),
              width: 300,
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        addSubject();
                      }),
                  hintText: '추가할 과목을 입력하세요',
                ),
              ),
            ),
          ]),
          FutureBuilder<List<Map<String, dynamic>>>(
              future: getUserData(
                  DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal())),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data!.isEmpty
                      ? Column(
                          children: const [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 50)),
                            Icon(Icons.warning_amber_rounded,
                                size: 100, color: Colors.grey),
                            Text(
                              "불러올 과목이 없습니다. 과목을 추가해주세요. \n혹은 인터넷 연결을 확인해주세요",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return WillPopScope(
                                          child: AlertDialog(
                                            title: Text("알림"),
                                            content: Text("해당 과목을 삭제하시겠습니까?"),
                                            actions: [
                                              TextButton(
                                                child: Text("삭제"),
                                                onPressed: () async {
                                                  bool success =
                                                      await removeSubject(
                                                          snapshot.data![index]
                                                              ['subject_name']);
                                                  if (success) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "과목을 성공적으로 삭제했습니다.");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "과목 삭제를 실패했습니다. 다시 시도해주세요");
                                                  }
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                              ),
                                              TextButton(
                                                child: Text("취소"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                          onWillPop: () async => false);
                                    });
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    //borderSide: const BorderSide(colo
                                  // r: Colors.purpleAccent, width: 1))
                                ),
                                child: ListTile(
                                  title: Text(
                                      '${snapshot.data![index]['subject_name']} \t ${snapshot.data![index]['study_time']}'),
                                  trailing: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Camera(
                                                subjectName:
                                                    snapshot.data![index]
                                                        ['subject_name'])),
                                      ).then((value) => setState(() {}));
                                    },
                                    child: const Text('공부 하기'),
                                  ),
                                ),
                              ),
                            );
                          });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              })
        ],
      ),
    );
  }
}
