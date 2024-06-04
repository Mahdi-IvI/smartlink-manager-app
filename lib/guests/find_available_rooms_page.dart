import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/user_access_model.dart';
import 'package:smart_link_manager/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_link_manager/my_home_page.dart';

import '../config/config.dart';
import '../models/place_model.dart';
import '../models/room_model.dart';
import '../rooms/room_card.dart';

class FindAvailableRoomsPage extends StatefulWidget {
  final UserModel user;
  final PlaceModel place;
  final DateTimeRange dateTimeRange;

  const FindAvailableRoomsPage(
      {super.key,
      required this.user,
      required this.place,
      required this.dateTimeRange});

  @override
  State<FindAvailableRoomsPage> createState() => _FindAvailableRoomsPageState();
}

class _FindAvailableRoomsPageState extends State<FindAvailableRoomsPage> {
  List<RoomModel> rooms = [];
  List<RoomModel> publicDoors = [];

  @override
  void initState() {
    getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.availableRooms),
      ),
      body: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return RoomCard(
              onTap: () {
                reserveRoomForGuest(room: rooms[index]);
              },
              room: rooms[index],
              place: widget.place,
            );
          }),
    );
  }

  Future getRooms() async {
    await Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.roomsCollection)
        .get()
        .then((QuerySnapshot snapshot) async {
      for (var room in snapshot.docs) {
        RoomModel roomModel = RoomModel.fromDocument(room);
        if (!roomModel.public) {
          await Config.fireStore
              .collection(Config.placesCollection)
              .doc(widget.place.id)
              .collection(Config.guestsCollection)
              .where(Config.roomId, isEqualTo: roomModel.id)
              .get()
              .then((QuerySnapshot guestSnapshot) {
                if(guestSnapshot.size==0){
                  if (!rooms.contains(roomModel)) {
                    setState(() {
                      rooms.add(roomModel);
                    });
                  }
                }else{
                  for (var guest in guestSnapshot.docs) {
                    GuestModel guestModel = GuestModel.fromDocument(guest);
                    if (!(widget.dateTimeRange.end
                        .isBefore(guestModel.startDateTime.toDate()) ||
                        widget.dateTimeRange.start
                            .isAfter(guestModel.endDateTime.toDate()))) {
                      break;
                    }
                    if (!rooms.contains(roomModel)) {
                      setState(() {
                        rooms.add(roomModel);
                      });
                    }
                  }
                }

          });
        } else {
          publicDoors.add(RoomModel.fromDocument(room));
        }
      }
    });
  }

  Future reserveRoomForGuest({required RoomModel room}) async {
    GuestModel guest = GuestModel(
        id: "id",
        guestId: widget.user.uid,
        roomId: room.id,
        startDateTime: Timestamp.fromDate(widget.dateTimeRange.start),
        endDateTime: Timestamp.fromDate(widget.dateTimeRange.end));

    await Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.guestsCollection)
        .add(guest.toJson())
        .whenComplete(() async {
      await Config.fireStore
          .collection(Config.userCollection)
          .doc(widget.user.uid)
          .collection(Config.userAccessCollection)
          .doc(widget.place.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        UserAccessModel placeAccess;
        if (documentSnapshot.exists) {
          placeAccess = UserAccessModel.fromDocument(documentSnapshot);
          if (placeAccess.startDateTime
              .toDate()
              .isAfter(widget.dateTimeRange.start)) {
            placeAccess.startDateTime =
                Timestamp.fromDate(widget.dateTimeRange.start);
          }
          if (placeAccess.endDateTime
              .toDate()
              .isBefore(widget.dateTimeRange.end)) {
            placeAccess.endDateTime =
                Timestamp.fromDate(widget.dateTimeRange.end);
          }

          await Config.fireStore
              .collection(Config.userCollection)
              .doc(widget.user.uid)
              .collection(Config.userAccessCollection)
              .doc(widget.place.id)
              .update(placeAccess.toJson())
              .then((value) async {
            await Config.fireStore
                .collection(Config.userCollection)
                .doc(widget.user.uid)
                .collection(Config.userAccessCollection)
                .doc(widget.place.id)
                .collection(Config.roomsCollection)
                .doc(room.id)
                .get()
                .then((DocumentSnapshot roomDocumentSnapshot) async {
              UserAccessModel roomAccess;
              if (roomDocumentSnapshot.exists) {
                roomAccess = UserAccessModel.fromDocument(roomDocumentSnapshot);
                if (placeAccess.startDateTime
                    .toDate()
                    .isAfter(widget.dateTimeRange.start)) {
                  roomAccess.startDateTime =
                      Timestamp.fromDate(widget.dateTimeRange.start);
                }
                if (roomAccess.endDateTime
                    .toDate()
                    .isBefore(widget.dateTimeRange.end)) {
                  roomAccess.endDateTime =
                      Timestamp.fromDate(widget.dateTimeRange.end);
                }
                await Config.fireStore
                    .collection(Config.userCollection)
                    .doc(widget.user.uid)
                    .collection(Config.userAccessCollection)
                    .doc(widget.place.id)
                    .collection(Config.roomsCollection)
                    .doc(room.id)
                    .update(roomAccess.toJson())
                    .whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Guest Added Successfully!")));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(place: widget.place)),
                      (route) => false);
                });
              } else {
                roomAccess = UserAccessModel(
                    id: room.id,
                    startDateTime:
                        Timestamp.fromDate(widget.dateTimeRange.start),
                    endDateTime: Timestamp.fromDate(widget.dateTimeRange.end));
                await Config.fireStore
                    .collection(Config.userCollection)
                    .doc(widget.user.uid)
                    .collection(Config.userAccessCollection)
                    .doc(widget.place.id)
                    .collection(Config.roomsCollection)
                    .doc(room.id)
                    .set(roomAccess.toJson())
                    .then((value) async {
                  for (var publicDoor in publicDoors) {
                    await Config.fireStore
                        .collection(Config.userCollection)
                        .doc(widget.user.uid)
                        .collection(Config.userAccessCollection)
                        .doc(widget.place.id)
                        .collection(Config.roomsCollection)
                        .doc(publicDoor.id)
                        .set(roomAccess.toJson());
                  }
                }).whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Guest Added Successfully!")));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(place: widget.place)),
                      (route) => false);
                });
              }
            });
          });
        } else {
          placeAccess = UserAccessModel(
              id: widget.place.id,
              startDateTime: Timestamp.fromDate(widget.dateTimeRange.start),
              endDateTime: Timestamp.fromDate(widget.dateTimeRange.end));
          await Config.fireStore
              .collection(Config.userCollection)
              .doc(widget.user.uid)
              .collection(Config.userAccessCollection)
              .doc(widget.place.id)
              .set(placeAccess.toJson())
              .then((value) async {
            UserAccessModel roomAccess = UserAccessModel(
                id: room.id,
                startDateTime: Timestamp.fromDate(widget.dateTimeRange.start),
                endDateTime: Timestamp.fromDate(widget.dateTimeRange.end));
            await Config.fireStore
                .collection(Config.userCollection)
                .doc(widget.user.uid)
                .collection(Config.userAccessCollection)
                .doc(widget.place.id)
                .collection(Config.roomsCollection)
                .doc(room.id)
                .set(roomAccess.toJson())
                .then((value) async {
              for (var publicDoor in publicDoors) {
                await Config.fireStore
                    .collection(Config.userCollection)
                    .doc(widget.user.uid)
                    .collection(Config.userAccessCollection)
                    .doc(widget.place.id)
                    .collection(Config.roomsCollection)
                    .doc(publicDoor.id)
                    .set(roomAccess.toJson());
              }
            }).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Guest Added Successfully!")));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(place: widget.place)),
                  (route) => false);
            });
          });
        }
      });
    });
  }
}
