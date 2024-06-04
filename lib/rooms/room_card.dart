import 'package:flutter/material.dart';
import 'package:smart_link_manager/components/my_text.dart';
import 'package:smart_link_manager/models/guest_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/room_model.dart';
import 'package:smart_link_manager/rooms/room_detail_page.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  final GuestModel? guest;
  final PlaceModel place;
  final VoidCallback? onTap;
  const RoomCard({super.key, required this.room, required this.place, this.onTap, this.guest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: InkWell(
        onTap: onTap??(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> RoomDetailPage(room: room, place: place)));
        },
        child: Card(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.meeting_room, size: 40,),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H3Text(text: room.name),
                      Text(room.location),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                if(guest==null)
                const Text("Available", style: TextStyle(color: Colors.green),),
                if(guest!=null)
                  const Text("Occupied", style: TextStyle(color: Colors.red),),
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
