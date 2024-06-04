import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_link_manager/config/config.dart';

class NewsModel {
  String id;
  String title;
  List images;
  String description;
  Timestamp publishDateTime;

  NewsModel(
      {required this.id,
      required this.title,
      required this.images,
      required this.description,
      required this.publishDateTime});

  factory NewsModel.fromDocument(DocumentSnapshot doc) {
    return NewsModel(
        id: doc.id,
        title: doc.get(Config.title),
        publishDateTime: doc.get(Config.publishDateTime),
        images: doc.get(Config.images),
        description: doc.get(Config.description));
  }

  Map<String, dynamic> toJson() => {
        Config.title: title,
        Config.images: images,
        Config.description: description,
        Config.publishDateTime: publishDateTime
      };
}
