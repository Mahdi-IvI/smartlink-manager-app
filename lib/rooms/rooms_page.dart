import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/rooms/room_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config/config.dart';
import '../models/room_model.dart';

class RoomsPage extends StatefulWidget {
  final bool? onlyShowAvailableRooms;
  final bool showAppbar;
  final PlaceModel place;

  const RoomsPage(
      {super.key,
      required this.place,
      this.onlyShowAvailableRooms,
      required this.showAppbar});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  Map<RoomModel, GuestModel?> rooms = {};

  @override
  void initState() {
    getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar
          ? AppBar(
              title: Text(widget.onlyShowAvailableRooms != null
                  ? widget.onlyShowAvailableRooms!
                      ? AppLocalizations.of(context)!.availableRooms
                      : AppLocalizations.of(context)!.occupiedRooms
                  : AppLocalizations.of(context)!.rooms),
            )
          : null,
      body: ListView.builder(
          itemCount: widget.onlyShowAvailableRooms != null
              ? widget.onlyShowAvailableRooms!
                  ? rooms.entries.where((r) => r.value == null).length
                  : rooms.entries.where((r) => r.value != null).length
              : rooms.length,
          itemBuilder: (context, index) {
            return RoomCard(
              guest: widget.onlyShowAvailableRooms != null
                  ? widget.onlyShowAvailableRooms!
                      ? rooms.entries
                          .where((r) => r.value == null)
                          .elementAt(index)
                          .value
                      : rooms.entries
                          .where((r) => r.value != null)
                          .elementAt(index)
                          .value
                  : rooms.entries.elementAt(index).value,
              room: widget.onlyShowAvailableRooms != null
                  ? widget.onlyShowAvailableRooms!
                      ? rooms.entries
                          .where((r) => r.value == null)
                          .elementAt(index)
                          .key
                      : rooms.entries
                          .where((r) => r.value != null)
                          .elementAt(index)
                          .key
                  : rooms.entries.elementAt(index).key,
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
        .where(Config.public, isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) async {
      for (var room in snapshot.docs) {
        RoomModel roomModel = RoomModel.fromDocument(room);
          await Config.fireStore
              .collection(Config.placesCollection)
              .doc(widget.place.id)
              .collection(Config.guestsCollection)
              .where(Config.roomId, isEqualTo: roomModel.id)
              .get()
              .then((QuerySnapshot guestSnapShot) {
            for (var guest in guestSnapShot.docs) {
              GuestModel guestModel = GuestModel.fromDocument(guest);
              if (!(DateTime.now()
                      .isBefore(guestModel.startDateTime.toDate()) ||
                  DateTime.now().isAfter(guestModel.endDateTime.toDate()))) {
                setState(() {
                  rooms.putIfAbsent(roomModel, () => guestModel);
                });
                break;
              }
            }
            if (!rooms.containsKey(roomModel)) {
              setState(() {
                rooms.putIfAbsent(roomModel, () => null);
              });
            }
          });

      }
    });
  }
}
