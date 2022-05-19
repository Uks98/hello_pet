import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({Key? key}) : super(key: key);

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File? pickedImage;
  DocumentSnapshot? documentSnapshot;
  String? url;

  final user = FirebaseAuth.instance.currentUser;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
    addImageFun(pickedImage!);
  }


  void addImageFun(File pickedImage) {}

  // 컬렉션명
  final String colName = "FirstDemo";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "location";
  final String fnDatetime = "datetime";
  final String imageUrl = "imageUrl";
  final String userId = "userId";
   final String userImage = 'userImage';

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();
  DocumentSnapshot? document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateDocDialog,
        child: Icon(Icons.add),
        backgroundColor: Color(0xff82A284),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(colName)
                      .orderBy(fnDatetime, descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");
                    else {
                      return snapshot.data != null
                          ? ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                DateTime dt = DateTime.now();
                                final time = DateFormat("yyyy/MM/dd일\n HH시 mm분")
                                    .format(dt);
                                return GestureDetector(
                                  onTap: () {
                                    showUpdateOrDeleteDocDialog(
                                        snapshot.data!.docs.first);
                                  },
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              pickedImage != null
                                                  ? Container(
                                                      child: Image.file(File(pickedImage!.path),fit: BoxFit.cover,),
                                                      width: 100,
                                                      height: 200,
                                                    )
                                                  : Container(
                                                      color: Colors.redAccent,
                                                    ),
                                              // Container(
                                              //   width: 150,
                                              //   height: 150,
                                              //   child: Image.network(document["imgUrl"],fit: BoxFit.cover,),
                                              // ),
                                              Text(
                                                document["name"],
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                time,
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              )
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                document["location"],
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : const LinearProgressIndicator();
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  void createDoc(String name, String description) async {
    //final userData =  await FirebaseFirestore.instance.collection(colName).doc(user!.uid).get();
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      userId: user!.uid,
      'picked_image': url,
      //userImage: userData['picked_image']
    });
  }

  // 문서 조회 (Read)
  void showDocument(User uid) {
    FirebaseFirestore.instance
        .collection(colName)
        .doc(user!.uid)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc);
    });
  }

  // 문서 갱신 (Update)
  void updateDoc(String doc, String name, String description) {
    FirebaseFirestore.instance.collection(colName).doc(user!.uid).update({
      fnName: name,
      fnDescription: description,
    });
  }

  // 문서 삭제 (Delete)
  void deleteDoc(String doc) {
    FirebaseFirestore.instance.collection(colName).doc(user!.uid).delete();
  }

  void showCreateDocDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _newNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _newDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Create"),
              onPressed: () {
                if (_newDescCon.text.isNotEmpty &&
                    _newNameCon.text.isNotEmpty) {
                  createDoc(_newNameCon.text, _newDescCon.text);
                }
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(onPressed: () {}, child: Text("이미지 추가"))
          ],
        );
      },
    );
  }

  void showReadDocSnackBar(DocumentSnapshot doc) {
    _scaffoldKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          duration: Duration(seconds: 5),
          content: Text(
              "$fnName: ${doc[fnName]}\n$fnDescription: ${doc[fnDescription]}"
              "\n$fnDatetime: ${timestampToStrDateTime(doc[fnDatetime])}"),
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc) {
    _undNameCon.text = doc[fnName];
    _undDescCon.text = doc[fnDescription];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update/Delete Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("취소"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("업데이트"),
              onPressed: () {
                final user1 = user;
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  updateDoc(doc.id, _undNameCon.text, _undDescCon.text);
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("삭제"),
              onPressed: () {
                deleteDoc(doc.id);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("선택"),
              onPressed: () {
                _pickImage();
              },
            ),
            FlatButton(
              child: Text("이미지 추가하기"),
              onPressed: () async {
                //이미지가 저장되는 클라우드 경로에 접근가능메서드
                final refImage = FirebaseStorage.instance
                    .ref()
                    .child('picked_image')
                    .child(user!.uid.toString() + '.png');
                await refImage.putFile(pickedImage!);
                url = await refImage.getDownloadURL();
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
