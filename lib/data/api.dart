

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data.dart';

List<PetData> data = [];
class Api{
  Future<List<PetData>> getData() async {
    String url = "https://openapi.gg.go.kr/AbdmAnimalProtect?KEY=c5a9cc5586474b3b86d6e203bd396b8c&Type=json&pSize=30";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String body= utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String,dynamic>;
      for(final _res in res["AbdmAnimalProtect"][1]["row"]){
        final m = PetData.fromJson(_res as Map<String,dynamic>);
        data.add(m);
      }
      return data;
    } else {
      throw Exception("error");
    }
  }
}
