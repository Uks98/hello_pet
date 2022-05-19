import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:search_pet/page/loginPage.dart';

import 'page/MAINPAGE.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "jua",
        primarySwatch: Colors.blue,
      ),
      home: const MyPage(),
    );
  }
}
