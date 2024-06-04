import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_link_manager/config/config.dart';


class MessageModel {
  String id;
  String text;
  String senderUid;
  Timestamp dateTime;

  MessageModel(
      {required this.id,
        required this.text,
        required this.senderUid,
        required this.dateTime});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
        id : doc.id,
        text: doc.get(Config.text),
        senderUid: doc.get(Config.senderUid),
        dateTime: doc.get(Config.dateTime));
  }


}