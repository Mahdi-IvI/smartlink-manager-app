import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/components/my_text.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/room_model.dart';
import 'package:smart_link_manager/rooms/rooms_page.dart';
import 'package:smart_link_manager/tickets/tickets_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'guests/add_guest_page.dart';
import 'chats/chat_page.dart';
import 'config/config.dart';
import 'news/news_page.dart';

class OverviewPage extends StatefulWidget {
  final PlaceModel place;

  const OverviewPage({super.key, required this.place});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<RoomModel> rooms = [];

  int? newTickets;
  int occupiedRoomCount = 0;

  @override
  void initState() {
    getRooms();
    getUnreadTicketsCount();
    getOccupiedRoomCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getRooms();
        getUnreadTicketsCount();
        getOccupiedRoomCount();
      },
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 200),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomsPage(
                                  place: widget.place,
                                  showAppbar: true,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              color: Colors.lightBlueAccent,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.meeting_room,
                            size: 40,
                          ),
                        ),
                        H3Text(
                            text:
                                "${AppLocalizations.of(context)!.allRooms}: ${rooms.where((element) => element.public == false).length}")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomsPage(
                                  place: widget.place,
                                  showAppbar: true,
                                  onlyShowAvailableRooms: true,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.meeting_room,
                            size: 40,
                          ),
                        ),
                        H3Text(
                            text:
                                "${AppLocalizations.of(context)!.availableRooms}: ${rooms.where((element) => element.public == false).length - occupiedRoomCount}")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomsPage(
                                  place: widget.place,
                                  showAppbar: true,
                                  onlyShowAvailableRooms: false,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.meeting_room,
                            size: 40,
                          ),
                        ),
                        H3Text(
                            text:
                                "${AppLocalizations.of(context)!.occupiedRooms}: $occupiedRoomCount")
                      ],
                    ),
                  ),
                ),
                if(widget.place.ticketSystemEnabled)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketsPage(
                                  place: widget.place,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Badge(
                          label: Text("${newTickets ?? 0}"),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.only(bottom: 20),
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: const Icon(
                              Icons.live_help,
                              size: 40,
                            ),
                          ),
                        ),
                        H3Text(text: AppLocalizations.of(context)!.tickets)
                      ],
                    ),
                  ),
                ),
                if(widget.place.groupChatEnabled)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  place: widget.place,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.only(bottom: 20),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const Icon(
                            Icons.forum_outlined,
                            size: 40,
                          ),
                        ),
                        H3Text(text: AppLocalizations.of(context)!.groupChat)
                      ],
                    ),
                  ),
                ),
                if(widget.place.newsEnabled)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsPage(
                                  place: widget.place,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.only(bottom: 20),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const Icon(
                            Icons.newspaper,
                            size: 40,
                          ),
                        ),
                        H3Text(text: AppLocalizations.of(context)!.news)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddGuestPage(
                            place: widget.place,
                          )));
            },
          )),
    );
  }

  Future getRooms() async {
    rooms.clear();
    Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.roomsCollection)
        .get()
        .then((QuerySnapshot snapshot) {
      List<RoomModel> roomsRes = [];
      for (var room in snapshot.docs) {
        RoomModel roomModel = RoomModel.fromDocument(room);
        roomsRes.add(roomModel);
      }
      setState(() {
        rooms = roomsRes;
      });
    });
  }

  Future getUnreadTicketsCount() async {
    Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.ticketsCollection)
        .where(Config.read, isEqualTo: false)
        .where(Config.lastSender, isNotEqualTo: Config.auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        newTickets = snapshot.size;
      });
    });
  }

  bool occupied(DateTime start, DateTime end) {
    if (!(DateTime.now().isBefore(start) || DateTime.now().isAfter(end))) {
      return true;
    } else {
      return false;
    }
  }

  Future getOccupiedRoomCount() async {
    occupiedRoomCount=0;
    await Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.guestsCollection)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var guest in snapshot.docs) {
        GuestModel guestModel = GuestModel.fromDocument(guest);
        if (!(DateTime.now().isBefore(guestModel.startDateTime.toDate()) ||
            DateTime.now().isAfter(guestModel.endDateTime.toDate()))) {
          setState(() {
            occupiedRoomCount++;
          });
        }
      }
    });
  }
}
