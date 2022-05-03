import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:themoviedb/Model/tv_show_detail_model.dart';

class Storage {
  static String favourite = 'favourite_tv_show';

  static saveTvShow(List<Results> persons) async {
    print(persons.length);
    SharedPreferences appPreferences = await SharedPreferences.getInstance();
    bool xyz = await appPreferences.setString(favourite, jsonEncode(persons));
    print(xyz);
  }

  static Future<List<Results>> getTvShow() async {
    SharedPreferences appPreferences = await SharedPreferences.getInstance();
    final List<dynamic> jsonData =
        jsonDecode(appPreferences.getString(favourite) ?? '[]');
    List<Results> list = jsonData.map<Results>((jsonList) {
      return Results.fromJson(jsonList);
    }).toList();

    return list;
  }
}
