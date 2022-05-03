import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/Model/tv_show_detail_model.dart';
import 'package:themoviedb/Provider/Apis.dart';
import 'package:themoviedb/Utils/loader.dart';
import 'package:themoviedb/Utils/shared_preference.dart';

class SearchShowScreen extends StatefulWidget {
  const SearchShowScreen({Key? key}) : super(key: key);

  @override
  _SearchShowScreenState createState() => _SearchShowScreenState();
}

class _SearchShowScreenState extends State<SearchShowScreen> {
  bool isApiCallRunning = false;
  List<Results>? tvShowDataList = [];
  TextEditingController searchController = TextEditingController();
  int resultEmpty = 0;
  List<Results> webDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    getLocalData();
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
        title: TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          inputFormatters: [
            NoLeadingSpaceFormatter(),
          ],
          onSubmitted: (val) {
            searchMyShow(val);
          },
          decoration: InputDecoration(hintText: "Search tv shows here..."),
        ),
      ),
      body: Container(
        child: resultEmpty != 0
            ? Container(
                child: Center(
                  child: Text(
                    "Result not found",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: tvShowDataList!.length,
                itemBuilder: (context, index) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${tvShowDataList![index].name.toString()}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${tvShowDataList![index].overview.toString()}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
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
                                            webDataList =
                                                await Storage.getTvShow();
                                            setState(() {});
                                          } else {
                                            webDataList
                                                .add(tvShowDataList![index]);
                                            Storage.saveTvShow(webDataList);
                                            webDataList =
                                                await Storage.getTvShow();
                                            setState(() {});
                                          }
                                        },
                                        child: favouriteTv(
                                                tvShowDataList![index].id!)
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
                                      Text(
                                          "${tvShowDataList![index].voteCount!}"),
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
    );
  }

  searchMyShow(String search) {
    if (isApiCallRunning == false) {
      Loader.sw(context);
      resultEmpty = 0;
      isApiCallRunning = true;
      setState(() {});
      TvShowProvider().searchShow(search).then((response) {
        isApiCallRunning = false;
        tvShowDataList?.clear();
        if (response != null) {
          if (response.results != null) {
            if (response.results?.length == 0) {
              resultEmpty = 1;
            }
            for (int i = 0; i < response.results!.length; i++) {
              tvShowDataList!.add(response.results![i]);
            }
            setState(() {});
            Loader.hd(context);
          } else {
            Loader.hd(context);
            resultEmpty = 2;
            setState(() {});
          }
        } else {
          Loader.hd(context);
          resultEmpty = 3;
          setState(() {});
        }
      }).catchError((onError) {
        isApiCallRunning = false;
        resultEmpty = 4;
        Loader.hd(context);
        setState(() {});
      });
    }
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
