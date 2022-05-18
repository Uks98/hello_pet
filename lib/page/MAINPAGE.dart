import 'package:flutter/material.dart';
import 'package:search_pet/data/api.dart';
import 'package:search_pet/page/add_pet.dart';
import 'package:search_pet/page/dumyPage.dart';
import 'package:search_pet/page/search_pet.dart';

class HubPage extends StatefulWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  State<HubPage> createState() => _HubPageState();
}
class _HubPageState extends State<HubPage> {
  int _currentIndex = 0;
  List<Widget>pageList = [SearchPet(),AddPetPage()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int idx){
          setState(() {
            _currentIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(icon:  Icon(Icons.search),label: "찾기"),
          BottomNavigationBarItem(icon:  Icon(Icons.add),label: "강아지 등록"),
        ],
      ),
      appBar: AppBar(
        title: const Text("FIND PET",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: Color(0xff82A284),
      ),
      body: Container(
        child: pageList.elementAt(_currentIndex),
      ),
    );
  }
}
