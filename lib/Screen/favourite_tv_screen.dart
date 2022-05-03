import 'package:flutter/material.dart';
import 'package:themoviedb/Model/tv_show_detail_model.dart';
import 'package:themoviedb/Utils/shared_preference.dart';

class FavouriteTvShowScreen extends StatefulWidget {
  const FavouriteTvShowScreen({Key? key}) : super(key: key);

  @override
  _FavouriteTvShowScreenState createState() => _FavouriteTvShowScreenState();
}

class _FavouriteTvShowScreenState extends State<FavouriteTvShowScreen> {
  List<Results> webDataList = [];

  @override
  void initState() {
    getLocalData();
    super.initState();
  }

  getLocalData() async {
    webDataList = await Storage.getTvShow();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite"),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: ListView.builder(
                  itemCount: webDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15)),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: webDataList[index].posterPath != null
                                    ? Image.network(
                                        "https://image.tmdb.org/t/p/w500${webDataList[index].posterPath}",
                                        fit: BoxFit.cover)
                                    : Container(
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${webDataList[index].name.toString()}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${webDataList[index].overview.toString()}',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            webDataList.removeAt(index);
                                            Storage.saveTvShow(webDataList);
                                            webDataList =
                                                await Storage.getTvShow();
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.thumb_up,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("${webDataList[index].voteCount}"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextSpan customTextTitle(String title) {
  return TextSpan(
      text: title,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20));
}

TextSpan customTextValue(String title) {
  return TextSpan(
      text: title, style: TextStyle(color: Colors.black, fontSize: 20));
}
