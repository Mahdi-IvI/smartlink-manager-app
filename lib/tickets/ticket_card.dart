import 'package:flutter/material.dart';
import 'package:smart_link_manager/chats/chat_page.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/ticket_model.dart';

import '../components/my_text.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final PlaceModel place;
  const TicketCard({super.key, required this.ticket, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(place: place, ticket: ticket,)));
        },
        child: Card(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.live_help, size: 40,),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H3Text(text: ticket.subject),
                      Text(ticket.description),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
