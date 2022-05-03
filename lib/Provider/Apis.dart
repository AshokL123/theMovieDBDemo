import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:themoviedb/Model/tv_show_detail_model.dart';

class TvShowProvider {
  Future<TvShowDetailModel?> getPopularTvShows(page) async {
    final url =
        "https://api.themoviedb.org/3/tv/airing_today?api_key=395fe78e959c13531af5c17518ab7152&language=en-US&page=$page";
    try {
      final response = await http.get(Uri.parse(url));
      final responseBody = jsonDecode(response.body);
      print("API CALL >> $url");
      print("RESPONSE >> ${response.body}");
      if (response.statusCode == 200) {
        TvShowDetailModel data = TvShowDetailModel.fromJson(responseBody);
        return data;
      } else if (response.statusCode == 101 || response.statusCode == 102) {
        TvShowDetailModel();
        return null;
      } else {
        TvShowDetailModel data = TvShowDetailModel.fromJson(responseBody);
        return data;
      }
    } catch (exception) {
      TvShowDetailModel data = TvShowDetailModel(
          page: 0, results: null, totalPages: 0, totalResults: 0);
      return data;
    }
  }

  Future<TvShowDetailModel?> searchShow(String query) async {
    final url =
        "https://api.themoviedb.org/3/search/tv?api_key=395fe78e959c13531af5c17518ab7152&query=$query";
    try {
      final response = await http.get(Uri.parse(url));
      final responseBody = jsonDecode(response.body);
      print("API CALL >> $url");
      print("RESPONSE >> ${response.body}");
      if (response.statusCode == 200) {
        TvShowDetailModel data = TvShowDetailModel.fromJson(responseBody);
        return data;
      } else if (response.statusCode == 101 || response.statusCode == 102) {
        TvShowDetailModel();
        return null;
      } else {
        TvShowDetailModel data = TvShowDetailModel.fromJson(responseBody);
        return data;
      }
    } catch (exception) {
      TvShowDetailModel data = TvShowDetailModel(
          page: 0, results: null, totalPages: 0, totalResults: 0);
      return data;
    }
  }
}
