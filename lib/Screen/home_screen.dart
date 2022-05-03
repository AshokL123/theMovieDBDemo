import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/Model/tv_show_detail_model.dart';
import 'package:themoviedb/Provider/Apis.dart';
import 'package:themoviedb/Screen/favourite_tv_screen.dart';
import 'package:themoviedb/Screen/search_tv_show_screen.dart';
import 'package:themoviedb/Utils/loader.dart';
import 'package:themoviedb/Utils/shared_preference.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  bool isLoaderShow = false;
  bool isApiCallRunning = false;
  List<Results>? tvShowDataList = [];
  ScrollController scrollController = ScrollController();

  List<Results> webDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    getTvShows();
    getLocalData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isApiCallRunning == false) {
          getTvShows();
        }
      }
    });

    super.initState();
  }

  getLocalData() async {
    webDataList = await Storage.getTvShow();
    setState(() {});
  }

  bool favouriteTv(int id) {
    bool isLike = false;

    for (int i = 0; i < webDataList.length; i++) {
      if (id == webDataList[i].id) {
        isLike = true;
        break;
      }
    }
    return isLike;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Tv Shows"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchShowScreen()));
              getLocalData();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              //FavouriteTvShowScreen
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavouriteTvShowScreen()));
              getLocalData();
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          controller: scrollController,
          itemCount: tvShowDataList!.length + 1,
          itemBuilder: (context, index) {
            if (index == tvShowDataList!.length) {
              return Container(
                height: 50,
                width: 50,
                child: Center(
                  child: Opacity(
                    opacity: isLoaderShow == true ? 1.0 : 00,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else {
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
                          child: tvShowDataList![index].posterPath != null
                              ? Image.network(
                                  "https://image.tmdb.org/t/p/w500${tvShowDataList![index].posterPath}",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${tvShowDataList![index].name.toString()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${tvShowDataList![index].overview.toString()}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (favouriteTv(
                                          tvShowDataList![index].id!)) {
                                        webDataList.removeWhere((element) =>
                                            element.id ==
                                            tvShowDataList![index].id!);
                                        Storage.saveTvShow(webDataList);
                                        webDataList = await Storage.getTvShow();
                                        setState(() {});
                                      } else {
                                        webDataList.add(tvShowDataList![index]);
                                        Storage.saveTvShow(webDataList);
                                        webDataList = await Storage.getTvShow();
                                        setState(() {});
                                      }
                                    },
                                    child:
                                        favouriteTv(tvShowDataList![index].id!)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite,
                                                color: Colors.grey,
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
                                  Text("${tvShowDataList![index].voteCount!}"),
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
            }
          },
        ),
      ),
    );
  }

  getTvShows() {
    if (isApiCallRunning == false) {
      if (page == 1) {
        Loader.sw(context);
      } else {
        isLoaderShow = true;
        setState(() {});
      }

      isApiCallRunning = true;
      TvShowProvider().getPopularTvShows(page).then((response) {
        isApiCallRunning = false;
        if (response != null) {
          if (response.results != null) {
            page++;
            for (int i = 0; i < response.results!.length; i++) {
              tvShowDataList!.add(response.results![i]);
            }
            Loader.hd(context);
            isLoaderShow = false;
            setState(() {});
          } else {
            Loader.hd(context);
            isLoaderShow = false;
            print("Response Result Null");
            setState(() {});
          }
        } else {
          Loader.hd(context);
          isLoaderShow = false;
          print("Response Null");
          setState(() {});
        }
      }).catchError((onError) {
        isApiCallRunning = false;
        isLoaderShow = false;
        Loader.hd(context);
        setState(() {});
      });
    }
  }
}
