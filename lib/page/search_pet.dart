import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_pet/data/api.dart';
import 'package:search_pet/data/data.dart';
import 'package:search_pet/page/show_detail.dart';

class SearchPet extends StatefulWidget {
  const SearchPet({Key? key}) : super(key: key);

  @override
  _SearchPetState createState() => _SearchPetState();
}

class _SearchPetState extends State<SearchPet> {
  late Future<List<PetData>> getPost;
  Api api = Api();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost = api.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            FutureBuilder<List<PetData>>(
                future: getPost,
                builder: (ctx, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, idx) {
                          final _data = data[idx];
                          return Container(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                    onTap: () => moveToDetail(context, _data),
                                    child: petBox(_data.mainImage, _data.pet,
                                        _data.startDay, _data.discovery))
                              ],
                            ),
                          );
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }

  void moveToDetail(BuildContext context, PetData _data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetail(
            character: _data.character,
            discovery: _data.discovery,
            mainImage: _data.mainImage,
            startDay: _data.startDay,
            pet: _data.pet,
            color: _data.color,
            condition: _data.condition),
      ),
    );
  }

  Widget petBox(String imgurl, String pet, String startDay, String discovery) {
    return Card(
        elevation: 4,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imgurl.isNotEmpty
                  ? Container(
                      width: 150,
                      height: 150,
                      child: Image.network(
                        imgurl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 150,
                      height: 150,
                      color: Colors.black,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '품종 : ${pet}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "등록일 : ${startDay}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  discovery.length <= 10
                      ? Text(
                          '구조장소: ${discovery}',
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(
                          '구조장소: \n${discovery}',
                          style: TextStyle(fontSize: 13),
                        ),
                ],
              ),
            ),
          ],
        ));
  }
}
