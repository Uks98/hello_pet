import 'package:flutter/material.dart';

class ShowDetail extends StatelessWidget {
  ShowDetail(
      {Key? key,
      required this.character,
      required this.discovery,
      required this.mainImage,
      required this.startDay,
      required this.pet,
      required this.color,
      required this.condition})
      : super(key: key);

  String startDay;
  String discovery;
  String condition;
  String mainImage;
  String color;
  String character;
  String pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FIND PET",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: Color(0xff82A284),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Image.network(mainImage,fit: BoxFit.contain,width: MediaQuery.of(context).size.width,height: 350,),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    SizedBox(height: 5,),
                    Row(children: [
                      Text("색상 : $color" + " / ",style: TextStyle(fontSize: 16),),
                      Text("발견날짜 : $startDay",style: TextStyle(fontSize: 16),),
                    ],),
                    SizedBox(height: 5,),
                    Divider(thickness: 2,endIndent: 10,indent: 10,),
                    Text("발견장소 : $discovery",style: TextStyle(fontSize: 16),),
                    SizedBox(height: 5,),
                    Text("특이사항 : $condition",style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
