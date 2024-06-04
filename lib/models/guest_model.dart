import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class GuestModel {
  String id;
  String guestId;
  String roomId;
  Timestamp startDateTime;
  Timestamp endDateTime;

  GuestModel(
      {required this.id,
      required this.guestId,
      required this.roomId,
      required this.startDateTime,
      required this.endDateTime});

  factory GuestModel.fromDocument(DocumentSnapshot doc) {
    return GuestModel(
      id: doc.id,
      guestId: doc.get(Config.guestId),
      roomId: doc.get(Config.roomId),
      startDateTime: doc.get(Config.startDateTime),
      endDateTime: doc.get(Config.endDateTime),
    );
  }

  Map<String, dynamic> toJson() => {
    Config.guestId: guestId,
    Config.roomId: roomId,
    Config.startDateTime: startDateTime,
    Config.endDateTime: endDateTime
  };
}
