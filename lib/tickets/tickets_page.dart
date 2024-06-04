import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/tickets/ticket_card.dart';

import '../config/config.dart';
import '../models/ticket_model.dart';

class TicketsPage extends StatefulWidget {
  final PlaceModel place;
  const TicketsPage({super.key, required this.place});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {

  List<TicketModel> tickets=[];

  @override
  void initState() {
    getTickets();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tickets"),
      ),
      body: ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index){
        return TicketCard(ticket: tickets[index], place: widget.place,);
      }),
    );
  }

  Future getTickets() async{
    await Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.ticketsCollection)
        .orderBy(Config.read)
        .orderBy(Config.lastMessageDateTime,descending: true)
        .where(Config.lastSender,isNotEqualTo: widget.place.id)
        .get()
        .then((QuerySnapshot snapshot) {
      List<TicketModel> ticketsRes = [];
      for (var room in snapshot.docs) {
        TicketModel ticketModel = TicketModel.fromDocument(room);
        ticketsRes.add(ticketModel);
      }
      setState(() {
        tickets = ticketsRes;
      });

    });
  }
}
