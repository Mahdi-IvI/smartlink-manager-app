import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/components/my_text.dart';
import 'package:smart_link_manager/components/title_subtitle_list_tile.dart';
import 'package:smart_link_manager/config/my_colors.dart';
import 'package:smart_link_manager/config/config.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/history_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/room_model.dart';
import 'package:smart_link_manager/models/user_model.dart';

import '../components/loading.dart';

class RoomDetailPage extends StatefulWidget {
  final RoomModel room;
  final GuestModel? guest;
  final PlaceModel place;

  const RoomDetailPage({super.key, required this.room, required this.place, this.guest});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  Map<String, UserModel> users = {};

  @override
  void initState() {
    if(widget.guest!=null){
      getCurrentGuest();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "Address", subtitle: widget.room.location),
                ),
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "status",
                      subtitle: widget.room.status ? "open" : "close"),
                ),
              ],
            ),
              Row(
              children: [
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "current guest", subtitle: widget.guest!=null ? widget.guest!.id : ""),
                ),
                if(widget.guest!= null)
                  Expanded(
                    child: TitleSubtitleListTile(title: "occupiedTill",
                        subtitle: Config.dateTimeFormatter.format(widget.guest!.endDateTime.toDate())),
                  ),
              ],
            ),

            const H4Text(text: "last Activity"),
            FirestorePagination(
                shrinkWrap: true,
                onEmpty: const Center(child: Text("nothing found!!!")),
                initialLoader: const Loading(),
                viewType: ViewType.list,
                itemBuilder: (context, documentSnapshots, index) {
                  HistoryModel model =
                      HistoryModel.fromDocument(documentSnapshots);

                  return logWidget(model: model, size: size, index: index);
                },
                isLive: true,
                limit: 20,
                query: Config.fireStore
                    .collection(Config.placesCollection)
                    .doc(widget.place.id)
                    .collection(Config.roomsCollection)
                    .doc(widget.room.id)
                    .collection(Config.historyCollection)
                    .orderBy(Config.logDateTime, descending: true)),
          ],
        ),
      ),
    );
  }

  Widget logWidget(
      {required HistoryModel model, required Size size, required int index}) {
    if (users[model.loggerUid] == null) {
      Config.fireStore
          .collection(Config.userCollection)
          .doc(model.loggerUid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromDocument(value);
        setState(() {
          users.putIfAbsent(userModel.uid, () => userModel);
        });
      });
    }
    return Container(
      color: index % 2 == 1 ? MyColors.colorBorderLight : null,
      child: ListTile(
        title: Text(users[model.loggerUid] != null
            ? "${users[model.loggerUid]!.firstname} ${users[model.loggerUid]!.lastname}"
            : "Guest"),
        subtitle: Text(widget.room.name),
        trailing: Column(
          children: [
            Text(Config.dateTimeFormatter
                .format(model.logDateTime.toDate())),
            Text(model.setStatusTo ? "open" : "close")
          ],
        ),
      ),
    );
  }

  Future getCurrentGuest() async {}
}
