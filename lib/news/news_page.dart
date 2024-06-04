import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/config/config.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:timeago/timeago.dart' as time_ago;

import '../components/emptyWidget.dart';
import '../components/loading.dart';
import '../models/news_model.dart';
import 'create_news.dart';
import 'news_detail_page.dart';

class NewsPage extends StatefulWidget {
  final PlaceModel place;
  const NewsPage({super.key, required this.place});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int refreshed = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        refreshed++;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "News",
          ),
        ),
        body: FirestorePagination(
          initialLoader: const Loading(),
          onEmpty: const EmptyWidget("News box is empty."),
          viewType: ViewType.list,
          itemBuilder: (context, documentSnapshots, index) {
            NewsModel model = NewsModel.fromDocument(documentSnapshots);
            return Row(
              children: [
                SizedBox(
                  width: size.width/3,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: model.images.isEmpty
                        ? Image.asset(Config.logoAddress)
                        : Image.network(
                      model.images[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: Loading());
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          model.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                model.description,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    time_ago.format(
                                        DateTime.fromMicrosecondsSinceEpoch(model
                                            .publishDateTime
                                            .microsecondsSinceEpoch),
                                        locale: 'en'),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetailPage(newsModel: model)));
                                },
                                child: const Text(
                                  "Read more...",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          limit: 10,
          isLive: true,
          query: Config.fireStore
              .collection(Config.placesCollection)
              .doc(widget.place.id)
              .collection(Config.newsCollection)
              .orderBy(Config.publishDateTime, descending: true),
          key: Key("$refreshed times"),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNews(place: widget.place,)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
