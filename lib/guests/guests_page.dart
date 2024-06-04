import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/guests/add_guest_page.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/room_model.dart';

import '../components/loading.dart';
import '../components/my_text.dart';
import '../config/config.dart';
import '../models/user_model.dart';

class GuestsPage extends StatefulWidget {
  final PlaceModel place;

  const GuestsPage({super.key, required this.place});

  @override
  State<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage> {
  Map<String, UserModel> users = {};
  Map<String, RoomModel> rooms = {};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FirestorePagination(
          shrinkWrap: true,
          onEmpty: const Center(child: Text("nothing found!!!")),
          initialLoader: const Loading(),
          viewType: ViewType.list,
          itemBuilder: (context, documentSnapshots, index) {
            GuestModel model = GuestModel.fromDocument(documentSnapshots);
            return guestWidget(model: model, size: size, index: index);
          },
          isLive: true,
          limit: 20,
          query: Config.fireStore
              .collection(Config.placesCollection)
              .doc(widget.place.id)
              .collection(Config.guestsCollection)
              .where(Config.endDateTime,
                  isGreaterThan: DateTime.now())
              .orderBy(Config.endDateTime, descending: true)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGuestPage(place: widget.place,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget guestWidget(
      {required GuestModel model, required size, required int index}) {
    if (users[model.guestId] == null) {
      Config.fireStore
          .collection(Config.userCollection)
          .doc(model.guestId)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromDocument(value);
        setState(() {
          users.putIfAbsent(userModel.uid, () => userModel);
        });
      });
    }
    if (rooms[model.roomId] == null) {
      Config.fireStore
          .collection(Config.placesCollection)
          .doc(widget.place.id)
          .collection(Config.roomsCollection)
          .doc(model.roomId)
          .get()
          .then((value) {
        RoomModel roomModel = RoomModel.fromDocument(value);
        setState(() {
          rooms.putIfAbsent(roomModel.id, () => roomModel);
        });
      });
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Card(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 40,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H3Text(text : users[model.guestId]!= null ? "${users[model.guestId]!.firstname} ${users[model.guestId]!.lastname}" : ""),
                      Text(rooms[model.roomId]!= null ? rooms[model.roomId]!.name : ""),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "from:\n${Config.dateTimeFormatter.format(model.startDateTime.toDate())}",
                    ),
                    Text(
                      "till:\n${Config.dateTimeFormatter.format(model.endDateTime.toDate())}",
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
